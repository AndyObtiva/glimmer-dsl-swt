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

      def call(new_model_collection=nil, internal_sort: false)
        Glimmer::SWT::DisplayProxy.instance.auto_exec(override_sync_exec: @model_binding.binding_options[:sync_exec], override_async_exec: @model_binding.binding_options[:async_exec]) do
          new_model_collection = model_binding_evaluated_property = @model_binding.evaluate_property unless internal_sort # this ensures applying converters (e.g. :on_read)
          table_cells = @table.swt_widget.items.map {|item| @table.column_properties.size.times.map {|i| item.get_text(i)} }
          model_cells = new_model_collection.to_a.map {|m| @table.cells_for(m)}
          return if table_cells == model_cells
          if new_model_collection and new_model_collection.is_a?(Array)
            @table_items_observer_registration&.unobserve
            @table_items_observer_registration = observe(new_model_collection, @column_properties)
            add_dependent(@table_observer_registration => @table_items_observer_registration)
            @model_collection = new_model_collection
          end
          populate_table(@model_collection, @table, @column_properties, internal_sort: internal_sort)
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
            table_item.setText(index, model.send(column_properties[index]).to_s)
          end
          table_item.set_data(model)
        end
        selected_table_items = parent.search {|item| selected_table_item_models.include?(item.get_data) }
        parent.swt_widget.setSelection(selected_table_items)
        sorted_model_collection = parent.sort!(internal_sort: internal_sort)
        call(sorted_model_collection, internal_sort: true) if @read_only_sort && !internal_sort && !sorted_model_collection.nil?
        parent.swt_widget.redraw if parent&.swt_widget&.respond_to?(:redraw)
      end
    end
  end
end
