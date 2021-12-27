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

require_relative 'cylinder'
require_relative 'cube'

class Quarto
  module View
    class Piece
      include Glimmer::UI::CustomShape
      
      SIZE = 28
      COLOR_LIGHT_WOOD = rgb(253, 252, 194)
      COLOR_DARK_WOOD = rgb(204, 108, 58)
      
      options :game, :model, :location_x, :location_y
      
      before_body do
        @background_color = model.light? ? COLOR_LIGHT_WOOD : COLOR_DARK_WOOD
      end
      
      body {
        shape(location_x, location_y) {
          if model.is_a?(Model::Piece::Cylinder)
            cylinder(cylinder_height: SIZE, oval_width: SIZE, oval_height: SIZE, pitted: model.pitted?, background_color: @background_color)
          else
            cube(cube_height: SIZE, rectangle_width: SIZE, rectangle_height: SIZE, pitted: model.pitted?, background_color: @background_color)
          end
        
          drag_source true
        }
      }
    end
  end
end
