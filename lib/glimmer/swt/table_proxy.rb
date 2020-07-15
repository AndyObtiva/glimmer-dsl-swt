require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    class TableProxy < Glimmer::SWT::WidgetProxy
      include Glimmer
      
      module TableListenerEvent        
        def table_item
          table_item_and_column_index[:table_item]
        end
        
        def column_index
          table_item_and_column_index[:column_index]
        end     
        
        private
        
        def table_item_and_column_index
          @table_item_and_column_index ||= find_table_item_and_column_index
        end
        
        def find_table_item_and_column_index
          {}.tap do |result|
            if respond_to?(:x) && respond_to?(:y)
              result[:table_item] = widget.getItems.detect do |ti|
                result[:column_index] = widget.getColumnCount.times.to_a.detect do |ci|
                  ti.getBounds(ci).contains(x, y)
                end
              end
            end
          end
        end   
      end
      
      attr_reader :table_editor, :table_editor_text_proxy, :sort_property, :sort_direction
      attr_accessor :column_properties
      
      def initialize(underscored_widget_name, parent, args)
        super
        @table_editor = TableEditor.new(swt_widget)
        @table_editor.horizontalAlignment = SWTProxy[:left]
        @table_editor.grabHorizontal = true
        @table_editor.minimumHeight = 20
      end

      def model_binding
        swt_widget.data
      end      
      
      def sort_by_column(table_column_proxy)
        index = swt_widget.columns.to_a.index(table_column_proxy.swt_widget)
        @sort_direction = @sort_direction.nil? || @sort_property != column_properties[index] || @sort_direction == :descending ? :ascending : :descending
        @sort_property = column_properties[index]
        @sort_type = String
        detect_sort_type        
        sort
      end
      
      def detect_sort_type
        array = model_binding.evaluate_property
        values = array.map { |object| object.send(sort_property) }
        value_classes = values.map(&:class).uniq
        if value_classes.size == 1
          @sort_type = value_classes.first
        elsif value_classes.include?(Integer)
          @sort_type = Integer
        elsif value_classes.include?(Float)
          @sort_type = Float
        end
      end
      
      def sort
        return unless sort_property && sort_direction
        array = model_binding.evaluate_property
        # Converting value to_s first to handle nil cases. Should work with numeric, boolean, and date fields
        sorted_array = array.sort_by do |object|
          value = object.send(sort_property)
          # handle nil and difficult to compare types gracefully
          if @sort_type == Integer
            value = value.to_i
          elsif @sort_type == Float
            value = value.to_f
          elsif @sort_type == String
            value = value.to_s
          end
          value
        end
        sorted_array = sorted_array.reverse if sort_direction == :descending
        model_binding.call(sorted_array)
      end
      
      # Performs a search for table items matching block condition
      # If no condition block is passed, returns all table items
      # Returns a Java TableItem array to easily set as selection on org.eclipse.swt.Table if needed
      def search(&condition)
        swt_widget.getItems.select {|item| condition.nil? || condition.call(item)}.to_java(TableItem)
      end
      
      # Returns all table items including descendants
      def all_table_items
        search
      end

      def widget_property_listener_installers
        super.merge({
          Java::OrgEclipseSwtWidgets::Table => {
            selection: lambda do |observer|
              on_widget_selected { |selection_event|
                observer.call(@swt_widget.getSelection)
              }
            end
          },        
        })
      end
      
      # Indicates if table is in edit mode, thus displaying a text widget for a table item cell
      def edit_mode?
        !!@edit_mode
      end
      
      def cancel_edit!
        @cancel_edit&.call if @edit_mode
      end

      def finish_edit!
        @finish_edit&.call if @edit_mode
      end

      # Indicates if table is editing a table item because the user hit ENTER or focused out after making a change in edit mode to a table item cell.
      # It is set to false once change is saved to model
      def edit_in_progress?
        !!@edit_in_progress
      end
      
      def edit_selected_table_item(column_index, before_write: nil, after_write: nil, after_cancel: nil)
        edit_table_item(swt_widget.getSelection.first, column_index, before_write: before_write, after_write: after_write, after_cancel: after_cancel)
      end
            
      def edit_table_item(table_item, column_index, before_write: nil, after_write: nil, after_cancel: nil)
        return if table_item.nil?
        @cancel_edit&.call if @edit_mode
        @edit_mode = true
        content {
          @table_editor_text_proxy = text {
            focus true
            text table_item.getText(column_index)
            action_taken = false
            @cancel_edit = lambda do
              @cancel_in_progress = true
              @table_editor_text_proxy&.swt_widget&.dispose
              @table_editor_text_proxy = nil
              after_cancel&.call
              @edit_in_progress = false
              @cancel_in_progress = false
              @cancel_edit = nil
              @edit_mode = false
            end
            @finish_edit = lambda do |event=nil|
              if table_item.isDisposed
                @cancel_edit.call
              elsif !action_taken && !@edit_in_progress && !@cancel_in_progress
                action_taken = true
                @edit_in_progress = true
                new_text = @table_editor_text_proxy.swt_widget.getText
                if new_text == table_item.getText(column_index)
                  @cancel_edit.call
                else
                  before_write&.call
                  table_item.setText(column_index, new_text)
                  model = table_item.getData
                  model.send("#{column_properties[column_index]}=", new_text) # makes table update itself, so must search for selected table item again
                  edited_table_item = search { |ti| ti.getData == model }.first
                  swt_widget.showItem(edited_table_item)
                  @table_editor_text_proxy&.swt_widget&.dispose
                  @table_editor_text_proxy = nil
                  after_write&.call(edited_table_item)
                  @edit_in_progress = false
                end
              end
            end
            on_focus_lost(&@finish_edit)
            on_key_pressed { |key_event|
              if key_event.keyCode == swt(:cr)
                @finish_edit.call(key_event)
              elsif key_event.keyCode == swt(:esc)
                @cancel_edit.call
              end
            }
          }
          @table_editor_text_proxy.swt_widget.selectAll
        }
        @table_editor.setEditor(@table_editor_text_proxy.swt_widget, table_item, column_index)
      end
      
      def add_listener(underscored_listener_name, &block)
        enhanced_block = lambda do |event|
          event.extend(TableListenerEvent)
          block.call(event)
        end
        super(underscored_listener_name, &enhanced_block)
      end
            
      private

      def property_type_converters
        super.merge({
          selection: lambda do |value|
            if value.is_a?(Array)
              search {|ti| value.include?(ti.getData) }
            else
              search {|ti| ti.getData == value}
            end
          end,
        })
      end
    end
  end
end
