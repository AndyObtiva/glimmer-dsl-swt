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

class Quarto
  module View
    class Cube
      include Glimmer::UI::CustomShape
      
      DEFAULT_SIZE = 28
      
      options :location_x, :location_y, :rectangle_width, :rectangle_height, :cube_height, :pitted, :background_color, :line_thickness
      alias pitted? pitted
      
      before_body do
        self.location_x ||= 0
        self.location_y ||= 0
        self.rectangle_width ||= rectangle_height || cube_height || DEFAULT_SIZE
        self.rectangle_height ||= rectangle_width || cube_height || DEFAULT_SIZE
        self.cube_height ||= rectangle_width || rectangle_height || DEFAULT_SIZE
        self.line_thickness ||= 1
      end
      
      body {
        shape(location_x, location_y) {
          polygon(0, cube_height + rectangle_height / 2.0, rectangle_width / 2.0, cube_height, rectangle_width, cube_height + rectangle_height / 2.0, rectangle_width / 2.0, cube_height + rectangle_height) {
            background background_color
          }
          polygon(0, cube_height + rectangle_height / 2.0, rectangle_width / 2.0, cube_height, rectangle_width, cube_height + rectangle_height / 2.0, rectangle_width / 2.0, cube_height + rectangle_height) {
            line_width line_thickness
          }
          rectangle(0, rectangle_height / 2.0, rectangle_width, cube_height) {
            background background_color
          }
          polyline(0, rectangle_height / 2.0 + cube_height, 0, rectangle_height / 2.0, rectangle_width, rectangle_height / 2.0, rectangle_width, rectangle_height / 2.0 + cube_height) {
            line_width line_thickness
          }
          polygon(0, rectangle_height / 2.0, rectangle_width / 2.0, 0, rectangle_width, rectangle_height / 2.0, rectangle_width / 2.0, rectangle_height) {
            background background_color
          }
          polygon(0, rectangle_height / 2.0, rectangle_width / 2.0, 0, rectangle_width, rectangle_height / 2.0, rectangle_width / 2.0, rectangle_height) {
            line_width line_thickness
          }
          line(rectangle_width / 2.0, cube_height + rectangle_height, rectangle_width / 2.0, rectangle_height) {
            line_width line_thickness
          }
          if pitted?
            oval(rectangle_width / 4.0, rectangle_height / 4.0, rectangle_width / 2.0, rectangle_height / 2.0) {
              background :black
            }
          end
        }
      }
    end
  end
end
