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

require_relative 'cylinder'
require_relative 'cube'

class Quarto
  module View
    class Piece
      include Glimmer::UI::CustomShape
      
      SIZE_SHORT = 28
      SIZE_TALL = 48
      BASIC_SHAPE_WIDTH = 48
      BASIC_SHAPE_HEIGHT = 28
      LINE_THICKNESS = 2
      
      options :game, :model, :location_x, :location_y
      
      before_body do
        @background_color = model.light? ? COLOR_LIGHT_WOOD : COLOR_DARK_WOOD
        @size = model.short? ? SIZE_SHORT : SIZE_TALL
        @shape_location_x = 0
        @shape_location_y = model.short? ? 20 : 0
      end
      
      body {
        shape(location_x, location_y) {
          if model.is_a?(Model::Piece::Cylinder)
            cylinder(location_x: @shape_location_x, location_y: @shape_location_y, cylinder_height: @size, oval_width: BASIC_SHAPE_WIDTH, oval_height: BASIC_SHAPE_HEIGHT, pitted: model.pitted?, background_color: @background_color, line_thickness: LINE_THICKNESS)
          else
            cube(location_x: @shape_location_x, location_y: @shape_location_y, cube_height: @size, rectangle_width: BASIC_SHAPE_WIDTH, rectangle_height: BASIC_SHAPE_HEIGHT, pitted: model.pitted?, background_color: @background_color, line_thickness: LINE_THICKNESS)
          end
        }
      }
    end
  end
end
