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
      attr_accessor :task, :done
      
      def initialize(task)
        @task = task
      end
    end
    
    class Presenter
      attr_accessor :new_todo_item_text, :todo_items
      
      def initialize
        reset!
        @todo_items = []
      end
      
      def save_new_todo_item!
        self.todo_items << TodoItem.new(@new_todo_item_text)
        reset!
      end
      
      private
      
      def reset!
        self.new_todo_item_text = 'What needs to be done?'
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
        
        }
        
        @new_todo_item_text = text {
          layout_data {
            width_hint 500
            height_hint 65
          }
          
          text <=> [@presenter, :new_todo_item_text]
          font name: 'Helvetica Neue', height: 24, style: :italic
          focus true
          
          on_focus_gained do
            @new_todo_item_text.select_all
          end
          
          on_key_pressed do |key_event|
            @presenter.save_new_todo_item!
          end
        }
      }
      
      @task_container = composite {
      }
      
      @action_panel = composite {
        row_layout(:horizontal) {
          margin_width 0
          margin_height 0
        }
        
        label {
          text '1 item left'
        }
        
        button {
          text 'All'
        }
        
        button {
          text 'Active'
        }
        
        button {
          text 'Completed'
        }
        
        button {
          text 'Clear Completed'
        }
      }
    }
  }
end

TodoMVC.launch
