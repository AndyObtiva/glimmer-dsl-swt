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
          an_oval = oval((rand*300).to_i, (rand*200).to_i, 50, 50) {
            background rgb(255, 165, 0)
            
            # declare shape as a drag source, which unlike `drag_and_move true`, it means the shape now
            # goes back to original position if not dropped at an on_drop shape target
            drag_source true
            
            # unspecified width and height become max width and max height by default
            oval(0, 0) {
              foreground :black
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
            ball_count = @number_shape.string.to_i
            @number_shape.dispose
            @drop_square.content {
              @number_shape = text {
                x :default
                y :default
                string (ball_count + 1).to_s
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
