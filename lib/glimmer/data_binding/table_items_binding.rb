# Copyright (c) 2007-2020 Andy Maleh
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

module Glimmer
  module DataBinding
    class TableItemsBinding
      include DataBinding::Observable
      include DataBinding::Observer
      include_package 'org.eclipse.swt'
      include_package 'org.eclipse.swt.widgets'

      def initialize(parent, model_binding, column_properties)
        @table = parent
        @model_binding = model_binding
        @table.swt_widget.data = @model_binding
        @column_properties = column_properties
        if @table.respond_to?(:column_properties=)
          @table.column_properties = @column_properties
        else # assume custom widget
          @table.body_root.column_properties = @column_properties
        end
        call(@model_binding.evaluate_property)
        @table_observer_registration = observe(model_binding)
        @table.on_widget_disposed do |dispose_event|
          unregister_all_observables
        end
      end

      def call(new_model_collection=nil)
        new_model_collection = @model_binding.evaluate_property # this ensures applying converters (e.g. :on_read)
        table_cells = @table.swt_widget.items.map {|item| @table.column_properties.size.times.map {|i| item.get_text(i)} }
        model_cells = new_model_collection.to_a.map {|m| @table.cells_for(m)}
        return if table_cells == model_cells
        if new_model_collection and new_model_collection.is_a?(Array)
          @table_items_observer_registration&.unobserve
          @table_items_observer_registration = observe(new_model_collection, @column_properties)
          add_dependent(@table_observer_registration => @table_items_observer_registration)
          @model_collection = new_model_collection
        end
        populate_table(@model_collection, @table, @column_properties)
      end
      
      def populate_table(model_collection, parent, column_properties)
        selected_table_item_models = parent.swt_widget.getSelection.map(&:getData)
        parent.finish_edit!
        parent.swt_widget.items.each(&:dispose)
        parent.swt_widget.removeAll
        model_collection.each do |model|
          table_item = TableItem.new(parent.swt_widget, SWT::SWTProxy[:none])
          for index in 0..(column_properties.size-1)
            table_item.setText(index, model.send(column_properties[index]).to_s)
          end
          table_item.setData(model)
        end
        selected_table_items = parent.search {|item| selected_table_item_models.include?(item.getData) }
        selected_table_items = [parent.swt_widget.getItems.first].to_java(TableItem) if selected_table_items.empty? && !parent.swt_widget.getItems.empty?
        parent.swt_widget.setSelection(selected_table_items) unless selected_table_items.empty?
        parent.sort!
        parent.swt_widget.redraw if parent&.swt_widget&.respond_to?(:redraw)
      end
    end
  end
end
