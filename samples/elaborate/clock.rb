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

include Glimmer

# TODO turn into a custom shell
shell {
  text 'Glimmer Clock'
  minimum_size 400, 420

  canvas {
    initial_time = Time.now
    animation {
      every 0.01 # in seconds (one thousandth)
            
      frame { |index| # frame block loops indefinitely (unless frame_count is set to an integer)
        # TODO cycle from green to yellow to blue
        background :yellow # sets canvas background color
        
        oval(0, 0, 400, 400) { # x, y, width, height
          # TODO make the color change cycle 15 seconds
          background rgb(155, index%255, index%255)
        }
        oval(0, 0, 400, 400) { # x, y, width, height
          foreground :yellow # sets oval background color
          line_width 5
        }
        # TODO replace arc with line
#         arc(0, 0, 400, 400, -1.4*index%360, 10) {  # x, y, width, height, start angle, arc angle
        # TODO divide correctly to ensure having 60 seconds around 360 degrees (with 1 hundredth of each or some other subdivision)
        arc(0, 0, 400, 400, 90 - ((Time.now - initial_time)*6), -1) {  # x, y, width, height, start angle, arc angle
          background rgb(200, 200, 50) # sets arc background color
        }
      }
    }
  }
}.open
