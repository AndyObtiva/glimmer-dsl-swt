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

require 'glimmer-dsl-swt'

class HelloCanvasDragAndDrop
  include Glimmer::UI::CustomShell
            
  body {
    shell {
      row_layout(:vertical) {
        margin_width 0
        margin_height 0
        fill true
        center true
      }
      text 'Hello, Canvas Drag & Drop!'
      
      label(:center) {
        text 'Drag orange balls and drop in the square.'
        font height: 16
      }
      
      canvas {
        layout_data {
          width 350
          height 350
        }
      
        background :white
        
        10.times do |n|
          value = rand(10)
          oval((rand*300).to_i, (rand*200).to_i, 50, 50) {
            data 'value', value
            background rgb(255, 165, 0)
            
            # declare shape as a drag source, which unlike `drag_and_move true`, it means the shape now
            # goes back to original position if not dropped at an on_drop shape target
            drag_source true
            
            # unspecified width and height become max width and max height by default
            oval(0, 0) {
              foreground :black
            }
            
            text {
              x :default
              y :default
              string value.to_s
            }
          }
        end
                                                          
        @drop_square = rectangle(150, 260, 50, 50) {
          background :white
                                                  
          # unspecified width and height become max width and max height by default
          @drop_square_border = rectangle(0, 0) {
            foreground :black
            line_width 3
            line_style :dash
          }
                    
          @number_shape = text {
            x :default
            y :default
            string '0'
          }
        
          on_mouse_move do
            @drop_square_border.foreground = :red if Glimmer::SWT::Custom::Shape.dragging?
          end
          
          on_drop do |drop_event|
            # drop_event attributes: :x, :y, :dragged_shape, :dragged_shape_original_x, :dragged_shape_original_y, :dragging_x, :dragging_y, :drop_shapes
            # drop_event.doit = false # drop event can be cancelled by setting doit attribute to false
            ball_count = @number_shape.string.to_i
            @number_shape.dispose
            @drop_square.content {
              @number_shape = text {
                x :default
                y :default
                string (ball_count + drop_event.dragged_shape.get_data('value')).to_s
              }
            }
            drop_event.dragged_shape.dispose
          end
        }
                                                                                  
        on_mouse_up do
          @drop_square_border.foreground = :black
        end
      }
    }
  }
end
 
HelloCanvasDragAndDrop.launch
