# Copyright (c) 2007-2024 Andy Maleh
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
    class Cylinder
      include Glimmer::UI::CustomShape
      
      DEFAULT_SIZE = 28
      
      options :location_x, :location_y, :oval_width, :oval_height, :cylinder_height, :pitted, :background_color, :line_thickness
      alias pitted? pitted
      
      before_body do
        self.location_x ||= 0
        self.location_y ||= 0
        self.oval_width ||= oval_height || cylinder_height || DEFAULT_SIZE
        self.oval_height ||= oval_width || cylinder_height || DEFAULT_SIZE
        self.cylinder_height ||= oval_width || oval_height || DEFAULT_SIZE
        self.line_thickness ||= 1
      end
      
      body {
        shape(location_x, location_y) {
          oval(0, cylinder_height, oval_width, oval_height) {
            background background_color
            
            oval { # draws with foreground :black and has max size within parent by default
              line_width line_thickness
            }
          }
          rectangle(0, oval_height / 2.0, oval_width, cylinder_height) {
            background background_color
          }
          polyline(0, oval_height / 2.0 + cylinder_height, 0, oval_height / 2.0, oval_width, oval_height / 2.0, oval_width, oval_height / 2.0 + cylinder_height) {
            line_width line_thickness
          }
          oval(0, 0, oval_width, oval_height) {
            background background_color
            
            oval { # draws with foreground :black and has max size within parent by default
              line_width line_thickness
            }
          }
          if pitted?
            oval(oval_width / 4.0, oval_height / 4.0, oval_width / 2.0, oval_height / 2.0) {
              background :black
            }
          end
        }
      }
    end
  end
end
