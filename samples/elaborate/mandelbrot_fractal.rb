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

# Mandelbrot implementation
# Courtesy of open-source code at:
# https://github.com/gotbadger/ruby-mandelbrot
class Mandelbrot

  attr_accessor :max_iterations

  def initialize(max_iterations)
    @max_iterations = max_iterations
  end

  def calculate(x,y)
    base_case = [Complex(x,y), 0]
    Array.new(max_iterations, base_case).inject(base_case) do |prev ,base|
      z, itr = prev
      c, _ = base
      val = z*z + c
      itr += 1 unless val.abs < 2
      [val, itr]
    end
  end
end

include Glimmer

colors = [[0, 0, 0]] + 40.times.map { |i| [255 - i*5, 255 - i*5, 55 + i*5] }
colors = colors.map {|color_data| rgb(*color_data).swt_color}
max_iter = colors.size - 1
mandelbrot = Mandelbrot.new(max_iter)
y_array = (1.0).step(-1,-0.0030).to_a
x_array = (-2.0).step(0.5,0.0030).to_a
height = y_array.size
width = x_array.size

shell {
  text 'Mandelbrot Fractal'
  minimum_size width, height + 12
  
  canvas {
    on_paint_control { |e|
      height.times { |y|
        width.times { |x|
          _, itr = mandelbrot.calculate(x_array[x], y_array[y])
          e.gc.foreground = colors[itr]
          e.gc.draw_point x, y
        }
      }
    }
  }
}.open
