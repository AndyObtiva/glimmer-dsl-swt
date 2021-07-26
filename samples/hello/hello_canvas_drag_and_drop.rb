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
        
        @drop_square_border = rectangle(150, 260, 50, 50) {
          foreground :black
          line_width 3
          line_style :dash
        }
                              
        @drop_square = rectangle(153, 263, 44, 44) {
          background :transparent
                    
          @number_shape = text {
            x :default
            y :default
            string '0'
          }
        
          on_mouse_move do
            if @dragging
              @drop_square_border.foreground = :red
            end
          end
          
          on_mouse_up do
            if @dragging
              ball_count = @number_shape.string.to_i
              @number_shape.dispose
              @drop_square.content {
                @number_shape = text {
                  x :default
                  y :default
                  string (ball_count + 1).to_s
                }
              }
              @dragging.dispose
            end
          end
        }
                                         
        10.times do |n|
          an_oval = oval((rand*300).to_i, (rand*200).to_i, 50, 50) {
            background rgb(255, 165, 0)

            on_drag_detected do |event|
              @dragging = an_oval
              @last_x = event.x
              @last_y = event.y
            end
          }
        end
                                         
        on_mouse_up do
          @drop_square_border.foreground = :black
          @dragging = nil
        end
              
        on_mouse_move do |event|
          if @dragging
            @dragging.move_by((event.x - @last_x), (event.y - @last_y))
            @last_x = event.x
            @last_y = event.y
          end
        end
      }
    }
  }
end
 
HelloCanvasDragAndDrop.launch
