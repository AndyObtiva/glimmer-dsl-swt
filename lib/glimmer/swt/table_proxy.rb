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
              result[:table_item] = widget.items.detect do |ti|
                result[:column_index] = widget.column_count.times.to_a.detect do |ci|
                  ti.getBounds(ci).contains(x, y)
                end
              end
            end
          end
        end
      end
      
      class << self
        def editors
          @editors ||= {
            # ensure editor can work with string keys not just symbols (leave one string in for testing)
            'text' => {
              widget_value_property: :text,
              editor_gui: lambda do |args, model, property, table_proxy|
                table_proxy.table_editor.minimumHeight = 20
                table_editor_widget_proxy = text(*args) {
                  text model.send(property)
                  focus true
                  on_focus_lost {
                    table_proxy.finish_edit!
                  }
                  on_key_pressed { |key_event|
                    if key_event.keyCode == swt(:cr)
                      table_proxy.finish_edit!
                    elsif key_event.keyCode == swt(:esc)
                      table_proxy.cancel_edit!
                    end
                  }
                }
                table_editor_widget_proxy.swt_widget.selectAll
                table_editor_widget_proxy
              end,
            },
            combo: {
              widget_value_property: :text,
              editor_gui: lambda do |args, model, property, table_proxy|
                first_time = true
                table_proxy.table_editor.minimumHeight = 25
                table_editor_widget_proxy = combo(*args) {
                  items model.send("#{property}_options")
                  text model.send(property)
                  focus true
                  on_focus_lost {
                    table_proxy.finish_edit!
                  }
                  on_key_pressed { |key_event|
                    if key_event.keyCode == swt(:cr)
                      table_proxy.finish_edit!
                    elsif key_event.keyCode == swt(:esc)
                      table_proxy.cancel_edit!
                    end
                  }
                  on_widget_selected {
                    if !OS.windows? || !first_time || first_time && model.send(property) != table_editor_widget_proxy.swt_widget.text
                      table_proxy.finish_edit!
                    end
                  }
                }
                table_editor_widget_proxy
              end,
            },
            checkbox: {
              widget_value_property: :selection,
              editor_gui: lambda do |args, model, property, table_proxy|
                first_time = true
                table_proxy.table_editor.minimumHeight = 25
                checkbox(*args) {
                  selection model.send(property)
                  focus true
                  on_widget_selected {
                    table_proxy.finish_edit!
                  }
                  on_focus_lost {
                    table_proxy.finish_edit!
                  }
                  on_key_pressed { |key_event|
                    if key_event.keyCode == swt(:cr)
                      table_proxy.finish_edit!
                    elsif key_event.keyCode == swt(:esc)
                      table_proxy.cancel_edit!
                    end
                  }
                }
              end,
            },
            date: {
              widget_value_property: :date_time,
              editor_gui: lambda do |args, model, property, table_proxy|
                first_time = true
                table_proxy.table_editor.minimumHeight = 25
                date(*args) {
                  date_time model.send(property)
                  focus true
                  on_focus_lost {
                    table_proxy.finish_edit!
                  }
                  on_key_pressed { |key_event|
                    if key_event.keyCode == swt(:cr)
                      table_proxy.finish_edit!
                    elsif key_event.keyCode == swt(:esc)
                      table_proxy.cancel_edit!
                    end
                  }
                }
              end,
            },
            date_drop_down: {
              widget_value_property: :date_time,
              editor_gui: lambda do |args, model, property, table_proxy|
                first_time = true
                table_proxy.table_editor.minimumHeight = 25
                date_drop_down(*args) {
                  date_time model.send(property)
                  focus true
                  on_focus_lost {
                    table_proxy.finish_edit!
                  }
                  on_key_pressed { |key_event|
                    if key_event.keyCode == swt(:cr)
                      table_proxy.finish_edit!
                    elsif key_event.keyCode == swt(:esc)
                      table_proxy.cancel_edit!
                    end
                  }
                }
              end,
            },
            time: {
              widget_value_property: :date_time,
              editor_gui: lambda do |args, model, property, table_proxy|
                first_time = true
                table_proxy.table_editor.minimumHeight = 25
                time(*args) {
                  date_time model.send(property)
                  focus true
                  on_focus_lost {
                    table_proxy.finish_edit!
                  }
                  on_key_pressed { |key_event|
                    if key_event.keyCode == swt(:cr)
                      table_proxy.finish_edit!
                    elsif key_event.keyCode == swt(:esc)
                      table_proxy.cancel_edit!
                    end
                  }
                }
              end,
            },
            radio: {
              widget_value_property: :selection,
              editor_gui: lambda do |args, model, property, table_proxy|
                first_time = true
                table_proxy.table_editor.minimumHeight = 25
                radio(*args) {
                  selection model.send(property)
                  focus true
                  on_widget_selected {
                    table_proxy.finish_edit!
                  }
                  on_focus_lost {
                    table_proxy.finish_edit!
                  }
                  on_key_pressed { |key_event|
                    if key_event.keyCode == swt(:cr)
                      table_proxy.finish_edit!
                    elsif key_event.keyCode == swt(:esc)
                      table_proxy.cancel_edit!
                    end
                  }
                }
              end,
            },
            spinner: {
              widget_value_property: :selection,
              editor_gui: lambda do |args, model, property, table_proxy|
                first_time = true
                table_proxy.table_editor.minimumHeight = 25
                table_editor_widget_proxy = spinner(*args) {
                  selection model.send(property)
                  focus true
                  on_focus_lost {
                    table_proxy.finish_edit!
                  }
                  on_key_pressed { |key_event|
                    if key_event.keyCode == swt(:cr)
                      table_proxy.finish_edit!
                    elsif key_event.keyCode == swt(:esc)
                      table_proxy.cancel_edit!
                    end
                  }
                }
                table_editor_widget_proxy
              end,
            },
          }
        end
      end
      
      attr_reader :table_editor, :table_editor_widget_proxy, :sort_property, :sort_direction, :sort_block, :sort_type, :sort_by_block, :additional_sort_properties, :editor, :editable, :initial_sort_property
      attr_accessor :column_properties
      alias editable? editable
      
      def initialize(underscored_widget_name, parent, args)
        @editable = args.delete(:editable)
        super
        @table_editor = TableEditor.new(swt_widget)
        @table_editor.horizontalAlignment = SWTProxy[:left]
        @table_editor.grabHorizontal = true
        @table_editor.minimumHeight = 20
        if editable?
          content {
            on_mouse_up { |event|
              edit_table_item(event.table_item, event.column_index)
            }
          }
        end
      end

      def model_binding
        swt_widget.data
      end
      
      def sort_block=(comparator)
        @sort_block = comparator
      end
      
      def sort_by_block=(property_picker)
        @sort_by_block = property_picker
      end
      
      def sort_property=(new_sort_property)
        @sort_property = [new_sort_property].flatten.compact
      end
      
      def detect_sort_type
        @sort_type = sort_property.size.times.map { String }
        array = model_binding.evaluate_property
        sort_property.each_with_index do |a_sort_property, i|
          values = array.map { |object| object.send(a_sort_property) }
          value_classes = values.map(&:class).uniq
          if value_classes.size == 1
            @sort_type[i] = value_classes.first
          elsif value_classes.include?(Integer)
            @sort_type[i] = Integer
          elsif value_classes.include?(Float)
            @sort_type[i] = Float
          end
        end
      end
      
      def column_sort_properties
        column_properties.zip(table_column_proxies.map(&:sort_property)).map do |pair|
          [pair.compact.last].flatten.compact
        end
      end
      
      # Sorts by specified TableColumnProxy object. If nil, it uses the table default sort instead.
      def sort_by_column!(table_column_proxy=nil)
        index = swt_widget.columns.to_a.index(table_column_proxy.swt_widget) unless table_column_proxy.nil?
        new_sort_property = table_column_proxy.nil? ? @sort_property : table_column_proxy.sort_property || [column_properties[index]]
        return if table_column_proxy.nil? && new_sort_property.nil? && @sort_block.nil? && @sort_by_block.nil?
        if new_sort_property && table_column_proxy.nil? && new_sort_property.size == 1 && (index = column_sort_properties.index(new_sort_property))
          table_column_proxy = table_column_proxies[index]
        end
        if new_sort_property && new_sort_property.size == 1 && !additional_sort_properties.to_a.empty?
          selected_additional_sort_properties = additional_sort_properties.clone
          if selected_additional_sort_properties.include?(new_sort_property.first)
            selected_additional_sort_properties.delete(new_sort_property.first)
            new_sort_property += selected_additional_sort_properties
          else
            new_sort_property += additional_sort_properties
          end
        end
        
        @sort_direction = @sort_direction.nil? || @sort_property.first != new_sort_property.first || @sort_direction == :descending ? :ascending : :descending
        swt_widget.sort_direction = @sort_direction == :ascending ? SWTProxy[:up] : SWTProxy[:down]
        
        @sort_property = [new_sort_property].flatten.compact
        table_column_index = column_properties.index(new_sort_property.to_s.to_sym)
        table_column_proxy ||= table_column_proxies[table_column_index] if table_column_index
        swt_widget.sort_column = table_column_proxy.swt_widget if table_column_proxy
                
        if table_column_proxy
          @sort_by_block = nil
          @sort_block = nil
        end
        @sort_type = nil
        if table_column_proxy&.sort_by_block
          @sort_by_block = table_column_proxy.sort_by_block
        elsif table_column_proxy&.sort_block
          @sort_block = table_column_proxy.sort_block
        else
          detect_sort_type
        end
                
        sort!
      end
      
      def initial_sort!
        sort_by_column!
      end
      
      def additional_sort_properties=(args)
        @additional_sort_properties = args unless args.empty?
      end
      
      def editor=(args)
        @editor = args
      end
      
      def cells_for(model)
        column_properties.map {|property| model.send(property)}
      end
      
      def cells
        column_count = @table.column_properties.size
        swt_widget.items.map {|item| column_count.times.map {|i| item.get_text(i)} }
      end
      
      def sort!
        return unless sort_property && (sort_type || sort_block || sort_by_block)
        array = model_binding.evaluate_property
        array = array.sort_by(&:hash) # this ensures consistent subsequent sorting in case there are equivalent sorts to avoid an infinite loop
        # Converting value to_s first to handle nil cases. Should work with numeric, boolean, and date fields
        if sort_block
          sorted_array = array.sort(&sort_block)
        elsif sort_by_block
          sorted_array = array.sort_by(&sort_by_block)
        else
          sorted_array = array.sort_by do |object|
            sort_property.each_with_index.map do |a_sort_property, i|
              value = object.send(a_sort_property)
              # handle nil and difficult to compare types gracefully
              if sort_type[i] == Integer
                value = value.to_i
              elsif sort_type[i] == Float
                value = value.to_f
              elsif sort_type[i] == String
                value = value.to_s
              end
              value
            end
          end
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
      
      def post_initialize_child(table_column_proxy)
        table_column_proxies << table_column_proxy
      end
      
      def post_add_content
        return if @initially_sorted
        initial_sort!
        @initially_sorted = true
      end
      
      def table_column_proxies
        @table_column_proxies ||= []
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
        require 'facets/hash/symbolize_keys'
        return if table_item.nil?
        model = table_item.data
        property = column_properties[column_index]
        cancel_edit!
        return unless table_column_proxies[column_index].editable?
        action_taken = false
        @edit_mode = true
        
        editor_config = table_column_proxies[column_index].editor || editor
        editor_config = editor_config.to_a
        editor_widget_options = editor_config.last.is_a?(Hash) ? editor_config.last : {}
        editor_widget_arg_last_index = editor_config.last.is_a?(Hash) ? -2 : -1
        editor_widget = (editor_config[0] || :text).to_sym
        editor_widget_args = editor_config[1..editor_widget_arg_last_index]
        model_editing_property = editor_widget_options[:property] || property
        widget_value_property = TableProxy::editors.symbolize_keys[editor_widget][:widget_value_property]
        
        @cancel_edit = lambda do |event=nil|
          @cancel_in_progress = true
          @table_editor_widget_proxy&.swt_widget&.dispose
          @table_editor_widget_proxy = nil
          after_cancel&.call
          @edit_in_progress = false
          @cancel_in_progress = false
          @cancel_edit = nil
          @edit_mode = false
        end
        
        @finish_edit = lambda do |event=nil|
          new_value = @table_editor_widget_proxy&.send(widget_value_property)
          if table_item.isDisposed
            @cancel_edit.call
          elsif !new_value.nil? && !action_taken && !@edit_in_progress && !@cancel_in_progress
            action_taken = true
            @edit_in_progress = true
            if new_value == model.send(model_editing_property)
              @cancel_edit.call
            else
              before_write&.call
              model.send("#{model_editing_property}=", new_value) # makes table update itself, so must search for selected table item again
              # Table refresh happens here because of model update triggering observers, so must retrieve table item again
              edited_table_item = search { |ti| ti.getData == model }.first
              swt_widget.showItem(edited_table_item)
              @table_editor_widget_proxy&.swt_widget&.dispose
              @table_editor_widget_proxy = nil
              after_write&.call(edited_table_item)
              @edit_in_progress = false
            end
          end
        end

        content {
          @table_editor_widget_proxy = TableProxy::editors.symbolize_keys[editor_widget][:editor_gui].call(editor_widget_args, model, model_editing_property, self)
        }
        @table_editor.setEditor(@table_editor_widget_proxy.swt_widget, table_item, column_index)
      rescue => e
        Glimmer::Config.logger.error {e.full_message}
        raise e
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
