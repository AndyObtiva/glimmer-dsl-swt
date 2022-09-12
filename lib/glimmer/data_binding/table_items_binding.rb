# Copyright (c) 2007-2022 Andy Maleh
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'set'

require 'glimmer/data_binding/observable_array'
require 'glimmer/data_binding/observable_model'
require 'glimmer/data_binding/observable'
require 'glimmer/data_binding/observer'
require 'glimmer/swt/swt_proxy'
require 'glimmer/swt/display_proxy'

module Glimmer
  module DataBinding
    class TableItemsBinding
      include DataBinding::Observable
      include DataBinding::Observer
      include_package 'org.eclipse.swt'
      include_package 'org.eclipse.swt.widgets'
      
      TABLE_ITEM_PROPERTIES = %w[background foreground font image]
      
      attr_reader :data_binding_done

      def initialize(parent, model_binding, column_properties = nil)
        @table = parent.is_a?(Glimmer::SWT::TableProxy) ? parent : parent.body_root # assume custom widget in latter case
        @table.table_items_binding = self
        @model_binding = model_binding
        @read_only_sort = @model_binding.binding_options[:read_only_sort]
        @table.editable = false if @model_binding.binding_options[:read_only]
        @table.column_properties = @model_binding.binding_options[:column_properties] || @model_binding.binding_options[:column_attributes] || column_properties
        @column_properties = @table.column_properties # normalized column properties
        Glimmer::SWT::DisplayProxy.instance.auto_exec(override_sync_exec: @model_binding.binding_options[:sync_exec], override_async_exec: @model_binding.binding_options[:async_exec]) do
          @table.swt_widget.data = @model_binding
          @table.swt_widget.set_data('table_items_binding', self)
          @table.on_widget_disposed do |dispose_event|
            unregister_all_observables
          end
          @table_observer_registration = observe(model_binding)
          call
        end
      end

      def call(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        internal_sort = options[:internal_sort] || false
        new_model_collection = args.first
        Glimmer::SWT::DisplayProxy.instance.auto_exec(override_sync_exec: @model_binding.binding_options[:sync_exec], override_async_exec: @model_binding.binding_options[:async_exec]) do
          new_model_collection = model_binding_evaluated_property = @model_binding.evaluate_property unless internal_sort # this ensures applying converters (e.g. :on_read)
          return if same_table_data?(new_model_collection)
          
          if same_model_collection?(new_model_collection)
            new_model_collection_attribute_values = model_collection_attribute_values(new_model_collection)
            @table.swt_widget.items.each_with_index do |table_item, row_index|
              next if new_model_collection_attribute_values[row_index] == @last_model_collection_attribute_values[row_index]
              model = table_item.get_data
              (0..(@column_properties.size-1)).each do |column_index|
                new_model_attribute_values_for_index = model_attribute_values_for_index(new_model_collection_attribute_values[row_index], column_index)
                last_model_attribute_values_for_index = model_attribute_values_for_index(@last_model_collection_attribute_values[row_index], column_index)
                next if new_model_attribute_values_for_index == last_model_attribute_values_for_index
                model_attribute = @column_properties[column_index]
                update_table_item_properties_from_model(table_item, row_index, column_index, model, model_attribute)
              end
            end
            @last_model_collection_attribute_values = new_model_collection_attribute_values
          else
            if new_model_collection and new_model_collection.is_a?(Array)
              @model_observer_registrations ||= {}
              @table_item_property_observation_mutex ||= Mutex.new
              
              brand_new_model_collection = !same_model_collection_with_different_sort?(new_model_collection)
              
              Thread.new do
                @data_binding_done = false
                @table_item_property_observation_mutex.synchronize do
                  deregister_model_observer_registrations
                
                  new_model_collection.each_with_index do |model, model_index|
                    @model_observer_registrations[model_index] ||= {}
                    @column_properties.each do |column_property|
                      model_observer_registration = observe(model, column_property)
                      @model_observer_registrations[model_index][column_property] = model_observer_registration
                      add_dependent(@table_observer_registration => model_observer_registration)
                    end
                  end
    
                  if brand_new_model_collection
                    new_model_collection.each_with_index do |model, model_index|
                      TABLE_ITEM_PROPERTIES.each do |table_item_property|
                        @column_properties.each do |column_property|
                          column_property = "#{column_property}_#{table_item_property}"
                          model_observer_registration = observe(model, column_property)
                          @model_observer_registrations[model_index][column_property] = model_observer_registration
                          add_dependent(@table_observer_registration => model_observer_registration)
                        end
                      end
                    end
                  end
                  @data_binding_done = true
                end
              end
              
              @model_collection = new_model_collection
            else
              @model_collection = []
            end
            
            populate_table(@model_collection, @table, @column_properties, internal_sort: internal_sort)
          end
        end
      end
      
      def populate_table(model_collection, parent, column_properties, internal_sort: false)
        selected_table_item_models = parent.swt_widget.getSelection.map(&:get_data)
        parent.finish_edit!
        dispose_start_index = @last_model_collection_attribute_values &&
                              (model_collection.count < @last_model_collection_attribute_values.count) &&
                              (@last_model_collection_attribute_values.count - (@last_model_collection_attribute_values.count - model_collection.count))
        if dispose_start_index
          table_items_to_dispose = parent.swt_widget.items[dispose_start_index..-1]
          parent.swt_widget.remove(dispose_start_index, (@last_model_collection_attribute_values.count-1))
          table_items_to_dispose.each(&:dispose)
        end
        model_collection.each_with_index do |model, row_index|
          table_item_exists = @last_model_collection_attribute_values &&
                              @last_model_collection_attribute_values.count > 0 &&
                              row_index < @last_model_collection_attribute_values.count
          table_item = table_item_exists ? parent.swt_widget.items[row_index] : TableItem.new(parent.swt_widget, SWT::SWTProxy[:none])
          (0..(column_properties.size-1)).each do |column_index|
            model_attribute = column_properties[column_index]
            update_table_item_properties_from_model(table_item, row_index, column_index, model, model_attribute)
          end
          table_item.set_data(model)
        end
        @last_model_collection_attribute_values = model_collection_attribute_values(model_collection)
        selected_table_items = parent.search {|item| selected_table_item_models.include?(item.get_data) }
        parent.swt_widget.setSelection(selected_table_items)
        sorted_model_collection = parent.sort!(internal_sort: internal_sort)
        call(sorted_model_collection, internal_sort: true) if @read_only_sort && !internal_sort && !sorted_model_collection.nil?
        parent.swt_widget.redraw if parent&.swt_widget&.respond_to?(:redraw)
      end
      
      def update_table_item_properties_from_model(table_item, row_index, column_index, model, model_attribute)
        Glimmer::SWT::DisplayProxy.instance.sync_exec do
          old_table_item_values = @last_model_collection_attribute_values &&
            @last_model_collection_attribute_values[row_index] &&
            model_attribute_values_for_index(@last_model_collection_attribute_values[row_index], column_index)
          text_value = model.send(model_attribute).to_s
          old_table_item_value = old_table_item_values && old_table_item_values[0]
          table_item.set_text(column_index, text_value) if old_table_item_value.nil? || text_value != old_table_item_value
          TABLE_ITEM_PROPERTIES.each do |table_item_property|
            if model.respond_to?("#{model_attribute}_#{table_item_property}")
              table_item_value = model.send("#{model_attribute}_#{table_item_property}")
              old_table_item_value = old_table_item_values && old_table_item_values[1 + TABLE_ITEM_PROPERTIES.index(table_item_property)]
              if old_table_item_value.nil? || (table_item_value != old_table_item_value)
                table_item_value = Glimmer::SWT::ColorProxy.create(*table_item_value).swt_color if table_item_value && %w[background foreground].include?(table_item_property.to_s)
                table_item_value = Glimmer::SWT::FontProxy.create(table_item_value).swt_font if table_item_value && table_item_property.to_s == 'font'
                table_item_value = Glimmer::SWT::ImageProxy.create(*table_item_value).swt_image if table_item_value && table_item_property.to_s == 'image'
                table_item.send("set_#{table_item_property}", column_index, table_item_value)
              end
            end
          end
        end
      end
      
      def same_table_data?(new_model_collection)
        (["text"] + TABLE_ITEM_PROPERTIES).all? do |table_item_property|
          table_cells = @table.swt_widget.items.map do |item|
            model = item.get_data
            @table.column_properties.each_with_index.map do |column_property, i|
              model_attribute = "#{column_property}"
              model_attribute = "#{model_attribute}_#{table_item_property}" if TABLE_ITEM_PROPERTIES.include?(table_item_property)
              item.send("get_#{table_item_property}", i) if model.respond_to?(model_attribute)
            end
          end
          model_cells = new_model_collection.to_a.map do |m|
            @table.cells_for(m, table_item_property: table_item_property)
          end
          model_cells = model_cells.map do |row|
            row.map do |model_cell|
              if model_cell
                if %w[background foreground].include?(table_item_property.to_s)
                  Glimmer::SWT::ColorProxy.create(*model_cell).swt_color
                elsif table_item_property.to_s == 'font'
                  Glimmer::SWT::FontProxy.create(model_cell).swt_font
                elsif table_item_property.to_s == 'image'
                  Glimmer::SWT::ImageProxy.create(*model_cell).swt_image
                else
                  model_cell
                end
              end
            end
          end
          table_cells == model_cells
        end
      end
      
      def same_model_collection?(new_model_collection)
        new_model_collection == table_item_model_collection
      end
      
      def same_model_collection_with_different_sort?(new_model_collection)
        Set.new(new_model_collection) == Set.new(table_item_model_collection)
      end
      
      def table_item_model_collection
        @table.swt_widget.items.map(&:get_data)
      end
      
      def deregister_model_observer_registrations
        @model_observer_registrations&.dup&.each do |model_index, model_column_properties|
          model_column_properties.dup.each do |column_property, model_observer_registration|
            remove_dependent(@table_observer_registration => model_observer_registration) if model_observer_registration
            model_observer_registration&.unobserve
            model_column_properties.delete(column_property)
          end
          @model_observer_registrations.delete(model_index)
        end
      end
      
      def model_collection_attribute_values(model_collection)
        model_collection.map do |model|
          (["text"] + TABLE_ITEM_PROPERTIES).map do |table_item_property|
            @table.cells_for(model, table_item_property: table_item_property)
          end
        end
      end
      
      def model_attribute_values_for_index(model_attribute_values, index)
        model_attribute_values.map {|attribute_values| attribute_values[index]}
      end
      
    end
  end
end
