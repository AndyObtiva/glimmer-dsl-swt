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

      def initialize(parent, model_binding, column_properties = nil)
        @table = parent
        @model_binding = model_binding
        @read_only_sort = @model_binding.binding_options[:read_only_sort]
        @column_properties = @model_binding.binding_options[:column_properties] || @model_binding.binding_options[:column_attributes] || column_properties
        @table.editable = false if @model_binding.binding_options[:read_only]
        if @table.respond_to?(:column_properties=)
          @table.column_properties = @column_properties
        else # assume custom widget
          @table.body_root.column_properties = @column_properties
        end
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
            # TODO if it's the same model collection, you should be updating table item cells piecemeal
            new_model_collection_attribute_values = model_collection_attribute_values(new_model_collection)
            @table.swt_widget.items.each_with_index do |table_item, i|
              next if @last_model_collection_attribute_values[i] == new_model_collection_attribute_values[i]
              model = table_item.get_data
              for index in 0..(@column_properties.size-1)
                model_attribute = @column_properties[index]
                update_table_item_properties_from_model(table_item, index, model, model_attribute)
              end
            end
            @last_model_collection_attribute_values = new_model_collection_attribute_values
          else
            if new_model_collection and new_model_collection.is_a?(Array)
              remove_dependent(@table_observer_registration => @table_items_observer_registration) if @table_items_observer_registration
              @table_items_observer_registration&.unobserve
              # TODO observe and update table items piecemeal per model
              # TODO ensure unobserving models when they are no longer data-bound to table
              @table_items_observer_registration = observe(new_model_collection, @column_properties)
              add_dependent(@table_observer_registration => @table_items_observer_registration)
              @table_items_property_observer_registration ||= {}
              TABLE_ITEM_PROPERTIES.each do |table_item_property|
                remove_dependent(@table_observer_registration => @table_items_property_observer_registration[table_item_property]) if @table_items_property_observer_registration[table_item_property]
                @table_items_property_observer_registration[table_item_property]&.unobserve
                property_properties = @column_properties.map {|property| "#{property}_#{table_item_property}" }
                @table_items_property_observer_registration[table_item_property] = observe(new_model_collection, property_properties)
                add_dependent(@table_observer_registration => @table_items_property_observer_registration[table_item_property])
              end
              @model_collection = new_model_collection
            end
            populate_table(@model_collection, @table, @column_properties, internal_sort: internal_sort)
          end
        end
      end
      
      def populate_table(model_collection, parent, column_properties, internal_sort: false)
        selected_table_item_models = parent.swt_widget.getSelection.map(&:get_data)
        parent.finish_edit!
        parent.swt_widget.items.each(&:dispose)
        parent.swt_widget.removeAll
        model_collection.each do |model|
          table_item = TableItem.new(parent.swt_widget, SWT::SWTProxy[:none])
          for index in 0..(column_properties.size-1)
            model_attribute = column_properties[index]
            update_table_item_properties_from_model(table_item, index, model, model_attribute)
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
      
      def update_table_item_properties_from_model(table_item, index, model, model_attribute)
        text_value = model.send(model_attribute).to_s
        table_item.set_text(index, text_value) unless table_item.get_text(index) == text_value
        TABLE_ITEM_PROPERTIES.each do |table_item_property|
          if model.respond_to?("#{model_attribute}_#{table_item_property}")
            table_item_value = model.send("#{model_attribute}_#{table_item_property}")
            if table_item_value
              table_item_value = Glimmer::SWT::ColorProxy.create(*table_item_value).swt_color if %w[background foreground].include?(table_item_property.to_s)
              table_item_value = Glimmer::SWT::FontProxy.new(table_item_value).swt_font if table_item_property.to_s == 'font'
              table_item_value = Glimmer::SWT::ImageProxy.create(*table_item_value).swt_image if table_item_property.to_s == 'image'
              table_item.send("set_#{table_item_property}", index, table_item_value) unless table_item.send("get_#{table_item_property}", index) == table_item_value
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
                  Glimmer::SWT::FontProxy.new(model_cell).swt_image
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
      
      def table_item_model_collection
        @table.swt_widget.items.map(&:get_data)
      end
      
      def model_collection_attribute_values(model_collection)
        model_collection.map do |model|
          (["text"] + TABLE_ITEM_PROPERTIES).map do |table_item_property|
            @table.cells_for(model, table_item_property: table_item_property)
          end.reduce(:+)
        end
      end
      
    end
  end
end
