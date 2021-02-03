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

require "complex"

class Mandelbrot

  attr_accessor :max_iterations

  def initialize(max_iterations)
    @max_iterations = max_iterations
  end
  
  def calculate(x,y)
    itr = 0
    val = 3
    z = base = Complex(x,y)
    until itr == @max_iterations || val.abs < 2
      c, _ = base
      val = z*z + c
      itr += 1
      z = val
    end
    z
  end
end

max_iter = 16

mandelbrot = Mandelbrot.new(max_iter)
REGEX_COLOR_HEX6 = /^#([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})$/

dimension = 70

# TODO calculate using 8 threads to take advantage of multiple cores
# mandelbrots = 70.times.map {[]}

include Glimmer

shell {
  minimum_size dimension, dimension + 12
  canvas {
    on_paint_control { |e|
      dimension.times { |x|
        dimension.times { |y|
  #         point(x, y) {
            calc = mandelbrot.calculate(x, y)
            
#             color_data = '#'+(calc.real%16_777_216).to_s(16)
#             color_data = color_data.match(REGEX_COLOR_HEX6).to_a.drop(1).map {|c| "0x#{c}".hex}.to_a
#             color_data = [:white] if color_data.nil? || color_data.empty?
            
#             foreground rgb(*color_data)
#             e.gc.setForeground rgb(*color_data).swt_color
            e.gc.setForeground rgb(calc.real > 0 ? :black : :white).swt_color
            e.gc.drawPoint(x, y)
  #         }
        }
      }
    }
  }
}.open
