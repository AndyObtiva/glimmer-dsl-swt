shell {
  minimum_size 300, 300
  text 'Hello, Draw2d!'
  canvas { |canvas_proxy|
    fill_layout;
    
    on_mouse_down { |event|
      @last_x = event.x
      @last_y = event.y
    }
    on_mouse_move { |event|
      if @shape_to_move
        old_x = @shape_to_move.location.x
        old_y = @shape_to_move.location.y
        new_x = old_x + event.x - @last_x
        new_y = old_y + event.y - @last_y
        @shape_to_move.setLocation(org.eclipse.draw2d.geometry.Point.new(new_x, new_y)) if @last_x && @last_y
        @last_x = event.x
        @last_y = event.y
      end
    }
    on_mouse_up { |event|
      @last_x = nil
      @last_y = nil
      @shape_to_move = nil
    }
    
    16.times {
      rectangle_figure {|proxy|
        focus_traversable true
        bounds org.eclipse.draw2d.geometry.Rectangle.new(10, 10, 80, 80)
        background_color color(:cyan).swt_color
        clipping_strategy(lambda {|child_figure| [org.eclipse.draw2d.geometry.Rectangle.new(0, 0, 5000, 5000)].to_java(org.eclipse.draw2d.geometry.Rectangle)})
        
        on_mouse_pressed { |event|
          @last_x = event.x
          @last_y = event.y
          @shape_to_move = canvas_proxy.top_level_figure.find_figure_at(event.x, event.y)
        }
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
          @shape_to_move = nil
        }
      }
      ellipse {|proxy|
        focus_traversable true
        fill true
        opaque true
        minimum_size org.eclipse.draw2d.geometry.Dimension.new(100, 100)
        preferred_size 100, 100
        background_color color(:red).swt_color
#         points org.eclipse.draw2d.geometry.PointList.new([13, 13, 50, 30, 40, 4].to_java(:int)) # points for a polygon alternative figure
        
        on_mouse_pressed { |event|
          @last_x = event.x
          @last_y = event.y
          @shape_to_move = canvas_proxy.top_level_figure.find_figure_at(event.x, event.y)
        }
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
          @shape_to_move = nil
        }
      }
    }
  }
}.open
