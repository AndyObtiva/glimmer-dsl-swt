shell {
  minimum_size 200, 200
  canvas {
    fill_layout;
    
    rectangle_figure {|proxy|
      bounds org.eclipse.draw2d.geometry.Rectangle.new(0, 0, 50, 50)
      background_color color(:cyan).swt_color
      opaque true
      
      on_mouse_dragged { |event|
        old_x = proxy.draw2d_figure.location.x
        old_y = proxy.draw2d_figure.location.y
        proxy.draw2d_figure.setLocation(org.eclipse.draw2d.geometry.Point.new(old_x + event.x - @last_x, old_y + event.y - @last_y)) if @last_x && @last_y
        @last_x = event.x
        @last_y = event.y
      }
      on_mouse_released {
        proxy.draw2d_figure.background_color = color([:green, :red, :blue].sample).swt_color
        @last_x = nil
        @last_y = nil
      }
      
      polygon {|proxy|
        fill true
        background_color color(:red).swt_color
        points org.eclipse.draw2d.geometry.PointList.new([13, 13, 50, 30, 40, 4].to_java(:int))
        
        on_mouse_dragged { |event|
          old_x = proxy.draw2d_figure.location.x
          old_y = proxy.draw2d_figure.location.y
          proxy.draw2d_figure.setLocation(org.eclipse.draw2d.geometry.Point.new(old_x + event.x - @last_x, old_y + event.y - @last_y)) if @last_x && @last_y
          @last_x = event.x
          @last_y = event.y
        }
        on_mouse_released {
          proxy.draw2d_figure.background_color = color([:green, :red, :blue].sample).swt_color
          @last_x = nil
          @last_y = nil
        }
      }
    }
  }
}.open
