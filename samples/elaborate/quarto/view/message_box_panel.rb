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
    class MessageBoxPanel
      include Glimmer::UI::CustomShape
      
      # TODO attempt to calculate from content automatically
      
      options :message, :location_x, :location_y
      option :size_width, default: 300
      option :size_height, default: 100
      option :background_color, default: :white
      option :foreground_color, default: :black
      option :border_line_width, default: 1
      option :text_font, default: {height: 16}
      option :text_color, default: :black
      
      before_body do
        self.location_x ||= (parent.size.x - size_width) / 2.0
        self.location_y ||= (parent.size.y - size_height) / 2.0
      end
      
      body {
        rectangle(location_x, location_y, size_width, size_height, round: true) {
          background background_color
          
          rectangle(round: true) { # border
            foreground foreground_color
            line_width border_line_width
          }
          
          text(message, :default, [:default, -15]) {
            foreground :black
            font text_font
          }
          
          rectangle(:default, [:default, 25], 80, 30, 15, 15, round: true) {
            foreground foreground_color
            line_width border_line_width
            
            text("OK") {
              foreground text_color
              font text_font
            }
          }
        }
      }
    end
  end
end
