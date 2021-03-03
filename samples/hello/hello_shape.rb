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
        crazy_ovals(-100, -100, 100, 100) {
          foreground :magenta
        }
        crazy_ovals(100, 100, 100, 100) {
          foreground :red
        }
        crazy_ovals(-100, 0, 100, 100) {
          foreground :dark_green
        }
        crazy_ovals(-100, 100, 100, 100) {
          foreground :dark_yellow
        }
        crazy_ovals(0, -100, 100, 100) {
          foreground :blue
        }
        crazy_ovals(100, -100, 100, 100) {
          foreground :dark_blue
        }
      }
    }
  }
  
  # method-based custom shape using `shape` keyword as a composite shape containing other shapes
  def crazy_ovals(x, y, width, height, &block)
    shape {
      # common attributes go here
      10.times { |n|
        oval(x + n, y + n, n*10%width, n*10%height) {
          line_width n%3
          block.call
        }
      }
    }
  end
end

HelloShape.launch
        
