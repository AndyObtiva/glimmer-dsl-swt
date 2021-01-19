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

shell {
  text 'Hello, Canvas Animation!'
  minimum_size 800, 400

  canvas { |canvas_proxy|
    animation {
      every 0.01
      frame {|index|
        background rgb(index%255, 100, 200)
#         rectangle(10, 10, 400, 400, fill: true) {
#           background rgb(index%255, 100, 200)
#         }
      }
    }
  }

  canvas { |canvas_proxy|
    colors = [:yellow, :red]
    animation {
      # TODO with every frame, unregister all older on_paint_control listeners (keep them booked in canvas widget)
      # assume only one animation runs at a time on the same canvas, save the animation too on canvas widgetproxy, and make any newer animations stop the previous ones
      every 0.5 # in seconds (every half a second)
      cycle colors
#       frame_count 30
#       cycle_count 3
#       started false
      
      frame { |index, color|
        outside_color = colors[index % 2]
        inside_color = colors[(index + 1) % 2]
        background outside_color
        rectangle(0, 0, 200, 200, fill: true) {
          background inside_color
        }
        rectangle(200, 200, 200, 200, fill: true) {
          background inside_color
        }
      }
    }
  }
# Demonstrate cycle_count and frame_count
#       animation(every: 1, cycle: colors, cycle_count: 1, frame_count: 30) { |frame, color|
}.open
