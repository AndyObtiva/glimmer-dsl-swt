# Copyright (c) 2007-2021 Andy Maleh
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

require 'glimmer-dsl-swt'

class TodoMVC
  include Glimmer::UI::CustomShell
  
  module Model
    class TodoItem
      class << self
        def all_todo_items
          @all_todo_items ||= []
        end
        
        attr_accessor :active_todo_items
        attr_accessor :completed_todo_items
        
        def update_active_and_completed_todo_items!
          self.active_todo_items = all_todo_items.select {|item| !item.done?}.to_a
          self.completed_todo_items = all_todo_items.select {|item| item.done?}.to_a
        end
      end

      attr_accessor :task, :done, :done_text
      alias done? done

      def initialize(task)
        @task = task
        TodoItem.all_todo_items << self
        TodoItem.update_active_and_completed_todo_items!
      end
      
      def done=(value)
        @done = value
        self.done_text = @done ? '✔' : ''
        TodoItem.update_active_and_completed_todo_items!
      end

      def done!
        self.done = true
      end
      
      def task=(value)
        @task = value
        delete! if @task.nil? || @task == ''
      end

      def delete!
        TodoItem.all_todo_items.delete(self)
        TodoItem.update_active_and_completed_todo_items!
      end
    end

    class Presenter
      DEFAULT_TASK = 'What needs to be done?'
      attr_accessor :new_todo_item_task, :filter, :todo_items

      def initialize
        reset_task!
        self.filter = :all
        @todo_items = []
        Glimmer::DataBinding::Observer.proc do
          populate_todo_items!
        end.observe(TodoItem.all_todo_items)
        Glimmer::DataBinding::Observer.proc do
          populate_todo_items!
        end.observe(self, :filter)
      end

      def populate_todo_items!
        self.todo_items = TodoItem.all_todo_items.select do |todo_item|
          case filter
          when :all
            true
          when :active
            !todo_item.done?
          when :completed
            todo_item.done?
          end
        end.to_a
      end

      def save_new_todo_item!
        TodoItem.new(@new_todo_item_task)
        reset_task!
      end

      def toggle_all_done!
        if TodoItem.all_todo_items.map(&:done).all?
          TodoItem.all_todo_items.each { |item| item.done = false }
        else
          TodoItem.all_todo_items.each(&:done!)
        end
      end

      def clear_completed!
        TodoItem.all_todo_items.delete_if(&:done?)
      end

      private

      def reset_task!
        self.new_todo_item_task = DEFAULT_TASK
      end
    end
  end

  before_body do
    @presenter = Model::Presenter.new
  end

  body {
    shell {
      row_layout(:vertical) {
        fill true
        center true
        margin_width 0
        margin_height 0
      }
      text 'Glimmer TodoMVC'
      minimum_size 500, 160

      label(:center) {
        text 'todos'
        font name: 'Helvetica Neue', height: 100
      }

      composite {
        grid_layout(2, false) {
          margin_width 0
          margin_height 0
        }

        arrow(:arrow, :down) {
          on_widget_selected do
            @presenter.toggle_all_done!
          end
        }

        @new_todo_item_text = text {
          layout_data {
            width_hint 500
            height_hint 65
          }

          text <=> [@presenter, :new_todo_item_task, after_read: ->(val) {@new_todo_item_text.select_all if val == Model::Presenter::DEFAULT_TASK}]
          font name: 'Helvetica Neue', height: 24, style: :italic
          focus true

          on_focus_gained do
            @new_todo_item_text.select_all
          end

          on_key_pressed do |key_event|
            @presenter.save_new_todo_item! if key_event.keyCode == swt(:cr)
          end
        }
      }

      @task_container = table(:editable) {
        header_visible false

        table_column {
          text 'Done'
          width 20
          editor :checkbox, property: :done
        }
        table_column {
          text 'Task'
          width 500
        }

        items <=> [@presenter, :todo_items, column_properties: [:done_text, :task]]
      }

      @action_panel = composite {
        row_layout(:horizontal) {
          margin_width 0
          margin_height 0
        }

        label {
          layout_data {
            width 100
          }
          text <= [Model::TodoItem, 'active_todo_items.to_a', on_read: ->(a) { a.nil? ? '          ' : "#{a.size} item#{a.size == 1 ? '' : 's'} left" }]
        }

        button {
          text 'All'

          on_widget_selected do
            @presenter.filter = :all
          end
        }

        button {
          text 'Active'

          on_widget_selected do
            @presenter.filter = :active
          end
        }

        button {
          text 'Completed'

          on_widget_selected do
            @presenter.filter = :completed
          end
        }

        button {
          text 'Clear Completed'
          visible <= [Model::TodoItem, 'completed_todo_items.to_a.any?']

          on_widget_selected do
            @presenter.clear_completed!
          end
        }
      }
    }
  }
end

TodoMVC.launch
