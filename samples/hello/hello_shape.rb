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

class HelloShape
  include Glimmer::UI::CustomShell
  
  body {
    shell {
      text 'Hello, Shape!'
      minimum_size 200, 225
    
      @canvas = canvas {
        background :white
        x_locations = []
        y_locations = []
        15.times { |n|
          begin
            x_locations[n] = (rand*125).to_i%200 + (rand*25).to_i
          end while x_locations[0...n].include?(x_locations[n])
          begin
            y_locations[n] = (rand*125).to_i%200 + (rand*25).to_i
          end while y_locations[0...n].include?(y_locations[n])
          foreground_color = rgb(rand*255, rand*255, rand*255)
          stick_figure(x_locations[n], y_locations[n], 50, 50) {
            foreground foreground_color
          }
        }
      }
    }
  }
  
  # method-based custom shape using `shape` keyword as a composite shape containing other shapes
  def stick_figure(x, y, width, height, &block)
    head_width = width*0.2
    head_height = height*0.2
    trunk_height = height*0.4
    extremity_length = height*0.4
    shape(x + head_width/2.0 + extremity_length, y) {
      # common attributes go here
      oval(0, 0, head_width, head_height) {
        block.call
      }
      line(head_width/2.0, head_height, head_width/2.0, head_height + trunk_height) {
        block.call
      }
      line(head_width/2.0, head_height + trunk_height, head_width/2.0 + extremity_length, head_height + trunk_height + extremity_length) {
        block.call
      }
      line(head_width/2.0, head_height + trunk_height, head_width/2.0 - extremity_length, head_height + trunk_height + extremity_length) {
        block.call
      }
      line(head_width/2.0, head_height*2, head_width/2.0 + extremity_length, head_height + trunk_height - extremity_length) {
        block.call
      }
      line(head_width/2.0, head_height*2, head_width/2.0 - extremity_length, head_height + trunk_height - extremity_length) {
        block.call
      }
    }
  end
end

HelloShape.launch
        
