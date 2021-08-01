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

require_relative 'parking/model/parking_presenter'
      
class Parking
  include Glimmer::UI::CustomShell
    
  FLOOR_COUNT = 4
  
  before_body do
    @parking_spots = Model::ParkingSpot::LETTERS.clone
    @parking_presenter = Model::ParkingPresenter.new(FLOOR_COUNT)
  end

  body {
    shell(:no_resize) {
      row_layout(:vertical) {
        center true
      }
    
      text 'Parking'
    
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
        maximum FLOOR_COUNT
        font height: 20
        selection <=> [@parking_presenter, :selected_floor]
        
        on_widget_selected do
          @parking_spots = Model::ParkingSpot::LETTERS.clone
          @canvas.dispose_shapes
          @canvas.content {
            parking_floor
          }
        end
      }
      @canvas = canvas {
        layout_data {
          width 600
          height 600
        }
        
        background :dark_gray
        
        parking_floor
      }
    }
  }
  
  def parking_floor
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
  end
        
  def parking_quad(location_x, location_y, length, &block)
    distance = (1.0/3)*length
    parking_spot(location_x, location_y, length, &block)
    parking_spot(location_x + distance, location_y, length, &block)
    parking_spot(location_x + 2*distance, location_y, length, &block)
    parking_spot(location_x + 3*distance, location_y, length, &block)
  end
      
  def parking_spot(location_x, location_y, length, &block)
    parking_spot_letter = @parking_spots.shift
    height = length
    width = (2.0/3)*length
    shape(location_x, location_y) { |the_shape|
      line_width (1.0/15)*length
      foreground :white
  
      block&.call(the_shape)
    
      rectangle(location_x, location_y, width, height) {
        background <= [
          @parking_presenter.floors[@parking_presenter.selected_floor - 1].parking_spots[parking_spot_letter],
          :booked,
          on_read: ->(b) {b ? :red : :dark_gray}
        ]
        
        text {
          x :default
          y :default
          string parking_spot_letter
          font height: 20
        }
        
        on_mouse_up do
          @parking_presenter.floors[@parking_presenter.selected_floor - 1].book!(parking_spot_letter)
          @parking_spots = Model::ParkingSpot::LETTERS.clone
          @canvas.dispose_shapes
          @canvas.content {
            parking_floor
          }
        end
      }
    
      line(location_x, location_y, location_x, location_y + height)
      line(location_x, location_y, location_x + width, location_y)
      line(location_x + width, location_y, location_x + width, location_y + height)
      
    }
  end
end
  
Parking.launch
  
