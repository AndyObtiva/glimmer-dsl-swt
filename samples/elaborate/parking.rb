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

class Parking
  include Glimmer::UI::CustomShell

  body {
    shell(:no_resize) {
      row_layout(:vertical) {
        center true
      }
      label {
        text 'Select an available spot to park'
        font height: 30
      }
      label {
        text 'Floor:'
        font height: 20
      }
      spinner {
        minimum 1
        maximum 4
        font height: 20
      }
      canvas {
        layout_data {
          width 600
          height 600
        }
        
        background :dark_gray
        
        parking_quad(67.5, 0, 125)
        parking_quad(67.5, 0, 125) { |shp|
          shp.rotate(90)
        }
        parking_quad(67.5, 0, 125) { |shp|
          shp.rotate(180)
        }
        parking_quad(67.5, 0, 125) { |shp|
          shp.rotate(270)
        }
      }
    }
  }
        
  def parking_quad(location_x, location_y, length, &block)
    distance = (1.0/3)*length
    parking_spot(location_x, location_y, length, &block)
    parking_spot(location_x + distance, location_y, length, &block)
    parking_spot(location_x + 2*distance, location_y, length, &block)
    parking_spot(location_x + 3*distance, location_y, length, &block)
  end
      
  def parking_spot(location_x, location_y, length, &block)
    height = length
    width = (2.0/3)*length
    marker_length = (1.0/6)*length
    shape(location_x, location_y) { |the_shape|
      line_width (1.0/15)*length
      foreground :white
  
      block&.call(the_shape)
    
      line(location_x, location_y, location_x, location_y + height)
      line(location_x, location_y, location_x + width, location_y)
      line(location_x + width, location_y, location_x + width, location_y + height)
      #line(location_x - marker_length, location_y + height, location_x + marker_length, location_y + height)
      #line(location_x + width - marker_length, location_y + height, location_x + width + marker_length, location_y + height)
    }
  end
end
  
Parking.launch
  
