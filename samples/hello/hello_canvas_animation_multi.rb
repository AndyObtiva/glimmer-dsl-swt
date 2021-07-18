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

include Glimmer

shell {
  text 'Hello, Canvas Animation Multi!'
  minimum_size 1200, 420

  canvas {
    background :white
    
    animation {
      every 0.01 # in seconds (one hundredth)
            
      frame { |index| # frame block loops indefinitely (unless frame_count is set to an integer)
        oval(0, 0, 400, 400) { # x, y, width, height
          foreground :black # sets oval background color
        }
        arc(0, 0, 400, 400, -1.4*index%360, 10) {  # x, y, width, height, start angle, arc angle
          background rgb(50, 200, 50) # sets arc background color
        }
      }
    }
  }

  canvas {
    background :white
    
    colors = [:yellow, :red]
    
    animation {
      every 0.25 # in seconds (one quarter)
      cycle colors # cycles array of colors into the second variable of the frame block below

      frame { |index, color| # frame block loops indefinitely (unless frame_count or cycle_count is set to an integer)
        outside_color = colors[index % 2]
        inside_color = colors[(index + 1) % 2]

        background outside_color # sets canvas background color

        rectangle(0, 0, 200, 200) {
          background inside_color # sets rectangle background color
        }
        rectangle(200, 200, 200, 200) {
          background inside_color # sets rectangle background color
        }
      }
    }
  }

  canvas {
    background :white
    
    colors = [:yellow, :red]
    
    animation {
      every 0.25 # in seconds (one quarter)
      cycle colors # cycles array of colors into the second variable of the frame block below

      frame { |index, color| # frame block loops indefinitely (unless frame_count or cycle_count is set to an integer)
        outside_color = colors[index % 2]
        inside_color = colors[(index + 1) % 2]

        background outside_color # sets canvas background color

        rectangle(0, 0, 200, 200) {
          background inside_color # sets rectangle background color
        }
        rectangle(200, 200, 200, 200) {
          background inside_color # sets rectangle background color
        }
      }
    }
    
    animation {
      every 0.01 # in seconds (one hundredth)
            
      frame { |index| # frame block loops indefinitely (unless frame_count is set to an integer)
        oval(0, 0, 400, 400) { # x, y, width, height
          foreground :black # sets oval background color
        }
        arc(0, 0, 400, 400, -1.4*index%360, 10) {  # x, y, width, height, start angle, arc angle
          background rgb(50, 200, 50) # sets arc background color
        }
      }
    }
  }
}.open
