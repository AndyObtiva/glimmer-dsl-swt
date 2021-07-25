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

class HelloCanvasShapeListeners
  include Glimmer::UI::CustomShell
  
  attr_accessor :shape_name, :listener_event, :dragged_shape

  body {
    shell {
      row_layout(:vertical) {
        fill true
        center true
        margin_width 0
        margin_height 0
      }
      
      text 'Hello, Canvas Shape Listeners!'
      
      label(:center) {
        text 'Current Shape:'
        font style: :bold
      }
      label(:center) {
        text <= [self, :shape_name]
      }
      
      label(:center) {
        text 'Current Event:'
        font style: :bold
      }
      label(:center) {
        text <= [self, :listener_event]
      }
      
      canvas { |canvas_proxy|
        layout_data {
          width 350
          height 200
        }
        
        background :white
      
        @rectangle = rectangle(25, 25, 50, 50) {
          background :red
                    
          # these listener events are limited to the rectangle bounds
                    
          on_mouse_down do |event|
            self.shape_name = 'Square'
            self.listener_event = 'Mouse Down'
          end
          
          on_drag_detected do |event|
            self.shape_name = 'Square'
            self.listener_event += ' / Drag Detected'
            self.dragged_shape = @rectangle
          end
          
          on_mouse_move do |event|
            if listener_event.to_s.empty? || shape_name != 'Square'
              self.listener_event = "Mouse Move"
            elsif !listener_event.to_s.include?('Mouse Move')
              self.listener_event += " / Mouse Move"
            end
            self.shape_name = 'Square'
          end
          
          on_mouse_up do |event|
            self.shape_name = 'Square'
            self.listener_event += ' / Mouse Up'
            self.dragged_shape = nil
          end
        }
        
        @oval = oval(150, 120, 50, 50) {
          background :green
          
          # these listener events are limited to the oval bounds
          
          on_mouse_down do |event|
            self.shape_name = 'Circle'
            self.listener_event = 'Mouse Down'
          end
          
          on_drag_detected do |event|
            self.shape_name = 'Circle'
            self.listener_event += ' / Drag Detected'
            self.dragged_shape = @oval
          end
          
          on_mouse_move do |event|
            if listener_event.to_s.empty? || shape_name != 'Circle'
              self.listener_event = "Mouse Move"
            elsif !listener_event.to_s.include?('Mouse Move')
              self.listener_event += " / Mouse Move"
            end
            self.shape_name = 'Circle'
          end
          
          on_mouse_up do |event|
            self.shape_name = 'Circle'
            self.listener_event += ' / Mouse Up'
            self.dragged_shape = nil
          end
        }
        
        @polygon = polygon(260, 25, 300, 25, 260, 65) {
          background :blue
          
          # these listener events are limited to the polygon bounds
          
          on_mouse_down do |event|
            self.shape_name = 'Triangle'
            self.listener_event = 'Mouse Down'
          end
          
          on_drag_detected do |event|
            self.shape_name = 'Triangle'
            self.listener_event += ' / Drag Detected'
            self.dragged_shape = @polygon
          end
          
          on_mouse_move do |event|
            if listener_event.to_s.empty? || shape_name != 'Triangle'
              self.listener_event = "Mouse Move"
            elsif !listener_event.to_s.include?('Mouse Move')
              self.listener_event += " / Mouse Move"
            end
            self.shape_name = 'Triangle'
          end
          
          on_mouse_up do |event|
            self.shape_name = 'Triangle'
            self.listener_event += ' / Mouse Up'
            self.dragged_shape = nil
          end
        }

        # This is a general canvas listener event, which is used to move shape even if mouse goes out of its bounds
        on_mouse_move do |event|
          dragged_shape.move_by(event.x - @last_x.to_f, event.y - @last_y.to_f) if dragged_shape
          @last_x = event.x
          @last_y = event.y
        end
      }
    }
  }
end

HelloCanvasShapeListeners.launch
