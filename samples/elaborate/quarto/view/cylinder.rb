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
    class Cylinder
      include Glimmer::UI::CustomShape
      
      DEFAULT_SIZE = 28
      
      options :location_x, :location_y, :top_width, :top_height, :cylinder_height, :pitted, :background_color
      alias pitted? pitted
      
      before_body do
        self.location_x ||= 0
        self.location_y ||= 0
        self.top_width ||= top_height || cylinder_height || DEFAULT_SIZE
        self.top_height ||= top_width || cylinder_height || DEFAULT_SIZE
        self.cylinder_height ||= top_width || top_height || DEFAULT_SIZE
      end
      
      body {
        shape(location_x, location_y) {
          oval(0, cylinder_height, top_width, top_height) {
            background background_color
            oval # draws with foreground :black and has max size within parent by default
          }
          rectangle(0, top_height / 2.0, top_width, cylinder_height) {
            background background_color
          }
          polyline(0, top_height / 2.0 + cylinder_height, 0, top_height / 2.0, top_width, top_height / 2.0, top_width, top_height / 2.0 + cylinder_height)
          oval(0, 0, top_width, top_height) {
            background background_color
            oval # draws with foreground :black and has max size within parent by default
          }
          if pitted?
            oval(top_width / 4.0 + 1, top_height / 4.0 + 1, top_width / 2.0, top_height / 2.0) {
              background :black
            }
          end
        }
      }
    end
  end
end
