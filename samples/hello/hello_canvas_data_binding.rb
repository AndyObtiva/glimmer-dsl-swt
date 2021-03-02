require 'glimmer-dsl-swt'

class HelloCanvasDataBinding
  include Glimmer::GUI::CustomWindow
  
  CANVAS_WIDTH  = 300
  CANVAS_HEIGHT = 300
  
  attr_accessor :x1_value, :y1_value, :x2_value, :y2_value, :foreground_red, :foreground_green, :foreground_blue, :line_width_value, :line_style_value
  
  def foreground_value
    rgb(foreground_red, foreground_green, foreground_blue)
  end
  
  def line_style_value_options
    [:line_solid, :line_dash, :line_dot, :line_dashdot, :line_dashdotdot]
  end
  
  before_body {
    self.x1_value = 0
    self.y1_value = 0
    self.x2_value = CANVAS_WIDTH
    self.y2_value = CANVAS_HEIGHT
    self.foreground_red = 28
    self.foreground_green = 128
    self.foreground_blue = 228
    self.line_width_value = 3
    self.line_style_value = :line_dot
  }
  
  body {
    shell {
      text 'Hello, Canvas Data-Binding!'
      
      tab_folder {
        tab_item {
          grid_layout(6, true) {
            margin_width 0
            margin_height 0
            horizontal_spacing 0
            vertical_spacing 0
          }
          text 'line'
          
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
            selection bind(self, :x1_value)
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_HEIGHT
            increment 3
            selection bind(self, :y1_value)
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
            selection bind(self, :x2_value)
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            maximum CANVAS_HEIGHT
            increment 3
            selection bind(self, :y2_value)
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
            selection bind(self, :foreground_red)
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            maximum 255
            increment 10
            selection bind(self, :foreground_green)
          }
          spinner {
            layout_data(:fill, :center, false, false) {
              horizontal_span 2
            }
            maximum 255
            increment 10
            selection bind(self, :foreground_blue)
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
            selection bind(self, :line_width_value)
          }
          combo(:read_only) {
            layout_data(:fill, :center, false, false) {
              horizontal_span 3
            }
            selection bind(self, :line_style_value)
          }
          canvas {
            layout_data(:center, :center, false, false) {
              horizontal_span 6
              width_hint CANVAS_WIDTH
              height_hint CANVAS_WIDTH
            }
            background :white
            
            line {
              x1 bind(self, :x1_value)
              y1 bind(self, :y1_value)
              x2 bind(self, :x2_value)
              y2 bind(self, :y2_value)
              foreground bind(self, :foreground_value, computed_by: [:foreground_red, :foreground_green, :foreground_blue])
              line_width bind(self, :line_width_value)
              line_style bind(self, :line_style_value)
            }
          }
        }
      }
    }
  }
  
end

HelloCanvasDataBinding.launch
