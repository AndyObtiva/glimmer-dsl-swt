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

class HelloCanvasDataBinding
  class PathShape
    attr_accessor :foreground_red, :foreground_green, :foreground_blue, :line_width_value, :line_style_value
    
    def foreground_value
      [foreground_red, foreground_green, foreground_blue]
    end
    
    def line_style_value_options
      [:solid, :dash, :dot, :dashdot, :dashdotdot]
    end
  end
  
  class LinePathShape < PathShape
    attr_accessor :x1_value, :y1_value, :x2_value, :y2_value
  end
  
  class QuadPathShape < PathShape
    attr_accessor :x1_value, :y1_value, :cx_value, :cy_value, :x2_value, :y2_value
    
    def point_array
      [x1_value, y1_value, cx_value, cy_value, x2_value, y2_value]
    end
  end
  
  class CubicPathShape < PathShape
    attr_accessor :x1_value, :y1_value, :cx1_value, :cy1_value, :cx2_value, :cy2_value, :x2_value, :y2_value
    
    def point_array
      [x1_value, y1_value, cx1_value, cy1_value, cx2_value, cy2_value, x2_value, y2_value]
    end
  end
  
  include Glimmer::GUI::Application # alias for Glimmer::UI::CustomShell / Glimmer::UI::CustomWindow
  
  CANVAS_WIDTH  = 300
  CANVAS_HEIGHT = 300
  
  before_body do
    @line = LinePathShape.new
    @line.x1_value = 5
    @line.y1_value = 5
    @line.x2_value = CANVAS_WIDTH - 5
    @line.y2_value = CANVAS_HEIGHT - 5
    @line.foreground_red = 28
    @line.foreground_green = 128
    @line.foreground_blue = 228
    @line.line_width_value = 3
    @line.line_style_value = :dash
    
    @quad = QuadPathShape.new
    @quad.x1_value = 5
    @quad.y1_value = CANVAS_HEIGHT - 5
    @quad.cx_value = (CANVAS_WIDTH - 10)/2.0
    @quad.cy_value = 5
    @quad.x2_value = CANVAS_WIDTH - 5
    @quad.y2_value = CANVAS_HEIGHT - 5
    @quad.foreground_red = 28
    @quad.foreground_green = 128
    @quad.foreground_blue = 228
    @quad.line_width_value = 3
    @quad.line_style_value = :dot
    
    @cubic = CubicPathShape.new
    @cubic.x1_value = 5
    @cubic.y1_value = (CANVAS_WIDTH - 10)/2.0
    @cubic.cx1_value = (CANVAS_WIDTH - 10)*0.25
    @cubic.cy1_value = (CANVAS_WIDTH - 10)*0.25
    @cubic.cx2_value = (CANVAS_WIDTH - 10)*0.75
    @cubic.cy2_value = (CANVAS_WIDTH - 10)*0.75
    @cubic.x2_value = CANVAS_WIDTH - 5
    @cubic.y2_value = (CANVAS_WIDTH - 10)/2.0
    @cubic.foreground_red = 28
    @cubic.foreground_green = 128
    @cubic.foreground_blue = 228
    @cubic.line_width_value = 3
    @cubic.line_style_value = :dashdot
  end
  
  body {
    shell(:no_resize) {
      text 'Hello, Canvas Data-Binding!'
      
      tab_folder {
        tab_item {
          grid_layout(6, true) {
            margin_width 0
            margin_height 0
            horizontal_spacing 0
            vertical_spacing 0
          }
          text 'Line'
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'x1'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'y1'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_WIDTH
            increment 3
            selection <=> [@line, :x1_value]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_HEIGHT
            increment 3
            selection <=> [@line, :y1_value]
          }
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'x2'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'y2'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_WIDTH
            increment 3
            selection <=> [@line, :x2_value]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_HEIGHT
            increment 3
            selection <=> [@line, :y2_value]
          }
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            text 'foreground red'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            text 'foreground green'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            text 'foreground blue'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            maximum 255
            increment 10
            selection <=> [@line, :foreground_red]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            maximum 255
            increment 10
            selection <=> [@line, :foreground_green]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            maximum 255
            increment 10
            selection <=> [@line, :foreground_blue]
          }
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'line width'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'line style'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum 255
            selection <=> [@line, :line_width_value]
          }
          combo(:read_only) {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            selection <=> [@line, :line_style_value]
          }
          
          @line_canvas = canvas {
            layout_data(:center, :center, false, false) {
              horizontal_span 6
              width_hint CANVAS_WIDTH
              height_hint CANVAS_WIDTH
            }
            
            background :white
            
            line {
              x1         <= [@line, :x1_value]
              y1         <= [@line, :y1_value]
              x2         <= [@line, :x2_value]
              y2         <= [@line, :y2_value]
              foreground <= [@line, :foreground_value, computed_by: [:foreground_red, :foreground_green, :foreground_blue]]
              line_width <= [@line, :line_width_value]
              line_style <= [@line, :line_style_value]
            }
            
            @line_oval1 = oval {
              x          <= [@line, :x1_value, on_read: ->(val) {val - 5}]
              y          <= [@line, :y1_value, on_read: ->(val) {val - 5}]
              width 10
              height 10
              background :black
            }
            
            @line_oval2 = oval {
              x          <= [@line, :x2_value, on_read: ->(val) {val - 5}]
              y          <= [@line, :y2_value, on_read: ->(val) {val - 5}]
              width 10
              height 10
              background :black
            }
            
            on_mouse_down do |mouse_event|
              @selected_shape = @line_canvas.shape_at_location(mouse_event.x, mouse_event.y)
              @selected_shape = nil unless @selected_shape.is_a?(Glimmer::SWT::Custom::Shape::Oval)
              @line_canvas.cursor = :hand if @selected_shape
            end
            
            on_drag_detected do |drag_detect_event|
              @drag_detected = true
              @drag_current_x = drag_detect_event.x
              @drag_current_y = drag_detect_event.y
            end
            
            on_mouse_move do |mouse_event|
              if @drag_detected && @selected_shape
                delta_x = mouse_event.x - @drag_current_x
                delta_y = mouse_event.y - @drag_current_y
                case @selected_shape
                when @line_oval1
                  @line.x1_value += delta_x
                  @line.y1_value += delta_y
                when @line_oval2
                  @line.x2_value += delta_x
                  @line.y2_value += delta_y
                end
                @drag_current_x = mouse_event.x
                @drag_current_y = mouse_event.y
              end
            end
            
            on_mouse_up do |mouse_event|
              @line_canvas.cursor = :arrow
              @drag_detected = false
              @selected_shape = nil
            end
          }
        }
        
        tab_item {
          grid_layout(6, true) {
            margin_width 0
            margin_height 0
            horizontal_spacing 0
            vertical_spacing 0
          }
          text 'Quad'
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'x1'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'y1'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_WIDTH
            increment 3
            selection <=> [@quad, :x1_value]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_HEIGHT
            increment 3
            selection <=> [@quad, :y1_value]
          }
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'control x'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'control y'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_WIDTH
            increment 3
            selection <=> [@quad, :cx_value]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_HEIGHT
            increment 3
            selection <=> [@quad, :cy_value]
          }
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'x2'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'y2'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_WIDTH
            increment 3
            selection <=> [@quad, :x2_value]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_HEIGHT
            increment 3
            selection <=> [@quad, :y2_value]
          }
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            text 'foreground red'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            text 'foreground green'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            text 'foreground blue'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            maximum 255
            increment 10
            selection <=> [@quad, :foreground_red]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            maximum 255
            increment 10
            selection <=> [@quad, :foreground_green]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            maximum 255
            increment 10
            selection <=> [@quad, :foreground_blue]
          }
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'line width'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'line style'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum 255
            selection <=> [@quad, :line_width_value]
          }
          combo(:read_only) {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            selection <=> [@quad, :line_style_value]
          }
          
          @quad_canvas = canvas {
            layout_data(:center, :center, false, false) {
              horizontal_span 6
              width_hint CANVAS_WIDTH
              height_hint CANVAS_WIDTH
            }
            
            background :white
            
            path {
              foreground  <= [@quad, :foreground_value, computed_by: [:foreground_red, :foreground_green, :foreground_blue]]
              line_width  <= [@quad, :line_width_value]
              line_style  <= [@quad, :line_style_value]
              
              quad {
                point_array <= [@quad, :point_array, computed_by: [:x1_value, :y1_value, :cx_value, :cy_value, :x2_value, :y2_value]]
              }
            }
            
            @quad_oval1 = oval {
              x          <= [@quad, :x1_value, on_read: ->(val) {val - 5}]
              y          <= [@quad, :y1_value, on_read: ->(val) {val - 5}]
              width 10
              height 10
              background :black
            }
            
            @quad_oval2 = oval {
              x          <= [@quad, :cx_value, on_read: ->(val) {val - 5}]
              y          <= [@quad, :cy_value, on_read: ->(val) {val - 5}]
              width 10
              height 10
              background :dark_gray
            }
            
            @quad_oval3 = oval {
              x          <= [@quad, :x2_value, on_read: ->(val) {val - 5}]
              y          <= [@quad, :y2_value, on_read: ->(val) {val - 5}]
              width 10
              height 10
              background :black
            }
            
            on_mouse_down do |mouse_event|
              @selected_shape = @quad_canvas.shape_at_location(mouse_event.x, mouse_event.y)
              @selected_shape = nil unless @selected_shape.is_a?(Glimmer::SWT::Custom::Shape::Oval)
              @quad_canvas.cursor = :hand if @selected_shape
            end
            
            on_drag_detected do |drag_detect_event|
              @drag_detected = true
              @drag_current_x = drag_detect_event.x
              @drag_current_y = drag_detect_event.y
            end
            
            on_mouse_move do |mouse_event|
              if @drag_detected && @selected_shape
                delta_x = mouse_event.x - @drag_current_x
                delta_y = mouse_event.y - @drag_current_y
                case @selected_shape
                when @quad_oval1
                  @quad.x1_value += delta_x
                  @quad.y1_value += delta_y
                when @quad_oval2
                  @quad.cx_value += delta_x
                  @quad.cy_value += delta_y
                when @quad_oval3
                  @quad.x2_value += delta_x
                  @quad.y2_value += delta_y
                end
                @drag_current_x = mouse_event.x
                @drag_current_y = mouse_event.y
              end
            end
            
            on_mouse_up do |mouse_event|
              @quad_canvas.cursor = :arrow
              @drag_detected = false
              @selected_shape = nil
            end
          }
        }
        
        tab_item {
          grid_layout(6, true) {
            margin_width 0
            margin_height 0
            horizontal_spacing 0
            vertical_spacing 0
          }
          text 'Cubic'
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'x1'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'y1'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_WIDTH
            increment 3
            selection <=> [@cubic, :x1_value]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_HEIGHT
            increment 3
            selection <=> [@cubic, :y1_value]
          }
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'control 1 x'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'control 1 y'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_WIDTH
            increment 3
            selection <=> [@cubic, :cx1_value]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_HEIGHT
            increment 3
            selection <=> [@cubic, :cy1_value]
          }
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'control 2 x'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'control 2 y'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_WIDTH
            increment 3
            selection <=> [@cubic, :cx2_value]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_HEIGHT
            increment 3
            selection <=> [@cubic, :cy2_value]
          }
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'x2'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'y2'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_WIDTH
            increment 3
            selection <=> [@cubic, :x2_value]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_HEIGHT
            increment 3
            selection <=> [@cubic, :y2_value]
          }
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            text 'foreground red'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            text 'foreground green'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            text 'foreground blue'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            maximum 255
            increment 10
            selection <=> [@cubic, :foreground_red]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            maximum 255
            increment 10
            selection <=> [@cubic, :foreground_green]
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            maximum 255
            increment 10
            selection <=> [@cubic, :foreground_blue]
          }
          
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'line width'
          }
          label {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            text 'line style'
          }
          
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum 255
            selection <=> [@cubic, :line_width_value]
          }
          combo(:read_only) {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            selection <=> [@cubic, :line_style_value]
          }
          
          @cubic_canvas = canvas {
            layout_data(:center, :center, false, false) {
              horizontal_span 6
              width_hint CANVAS_WIDTH
              height_hint CANVAS_WIDTH
            }
            
            background :white
            
            path {
              foreground  <= [@cubic, :foreground_value, computed_by: [:foreground_red, :foreground_green, :foreground_blue]]
              line_width  <= [@cubic, :line_width_value]
              line_style  <= [@cubic, :line_style_value]
              
              cubic {
                point_array <= [@cubic, :point_array, computed_by: [:x1_value, :y1_value, :cx1_value, :cy1_value, :cx2_value, :cy2_value, :x2_value, :y2_value]]
              }
            }
            
            @cubic_oval1 = oval {
              x          <= [@cubic, :x1_value, on_read: ->(val) {val - 5}]
              y          <= [@cubic, :y1_value, on_read: ->(val) {val - 5}]
              width 10
              height 10
              background :black
            }
            
            @cubic_oval2 = oval {
              x          <= [@cubic, :cx1_value, on_read: ->(val) {val - 5}]
              y          <= [@cubic, :cy1_value, on_read: ->(val) {val - 5}]
              width 10
              height 10
              background :dark_gray
            }
            
            @cubic_oval3 = oval {
              x          <= [@cubic, :cx2_value, on_read: ->(val) {val - 5}]
              y          <= [@cubic, :cy2_value, on_read: ->(val) {val - 5}]
              width 10
              height 10
              background :dark_gray
            }
            
            @cubic_oval4 = oval {
              x          <= [@cubic, :x2_value, on_read: ->(val) {val - 5}]
              y          <= [@cubic, :y2_value, on_read: ->(val) {val - 5}]
              width 10
              height 10
              background :black
            }
            
            on_mouse_down do |mouse_event|
              @selected_shape = @cubic_canvas.shape_at_location(mouse_event.x, mouse_event.y)
              @selected_shape = nil unless @selected_shape.is_a?(Glimmer::SWT::Custom::Shape::Oval)
              @cubic_canvas.cursor = :hand if @selected_shape
            end
            
            on_drag_detected do |drag_detect_event|
              @drag_detected = true
              @drag_current_x = drag_detect_event.x
              @drag_current_y = drag_detect_event.y
            end
            
            on_mouse_move do |mouse_event|
              if @drag_detected && @selected_shape
                delta_x = mouse_event.x - @drag_current_x
                delta_y = mouse_event.y - @drag_current_y
                case @selected_shape
                when @cubic_oval1
                  @cubic.x1_value += delta_x
                  @cubic.y1_value += delta_y
                when @cubic_oval2
                  @cubic.cx1_value += delta_x
                  @cubic.cy1_value += delta_y
                when @cubic_oval3
                  @cubic.cx2_value += delta_x
                  @cubic.cy2_value += delta_y
                when @cubic_oval4
                  @cubic.x2_value += delta_x
                  @cubic.y2_value += delta_y
                end
                @drag_current_x = mouse_event.x
                @drag_current_y = mouse_event.y
              end
            end
            
            on_mouse_up do |mouse_event|
              @cubic_canvas.cursor = :arrow
              @drag_detected = false
              @selected_shape = nil
            end
          }
        }
      }
    }
  }
end

HelloCanvasDataBinding.launch
