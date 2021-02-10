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

require 'complex'
require 'bigdecimal'
require 'concurrent-ruby'

# Mandelbrot implementation
# Courtesy of open-source code at:
# https://github.com/gotbadger/ruby-mandelbrot
class Mandelbrot

  attr_accessor :max_iterations

  def initialize(max_iterations)
    @max_iterations = max_iterations
    @pool = Concurrent::FixedThreadPool.new(Concurrent.processor_count)
  end
  
  def calculate_all(x_array, y_array)
    width = x_array.size
    height = y_array.size
    pixel_rows_array = Concurrent::Array.new(height)
    height.times do |y|
      pixel_rows_array[y] ||= Concurrent::Array.new(width)
      width.times do |x|
        @pool.post do
          pixel_rows_array[y][x] = calculate(x_array[x], y_array[y]).last
        end
      end
    end
    while pixel_rows_array.flatten.include?(nil)
      sleep(0.1)
    end
    pixel_rows_array
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

class MandelbrotFractal
  include Glimmer::UI::CustomShell
  
  attr_accessor :scale_value
  
  def scale_transform
    transform.scale(scale_value.to_i, scale_value.to_i).swt_transform
  end
  
  before_body {
    @colors = [[0, 0, 0]] + 40.times.map { |i| [255 - i*5, 255 - i*5, 55 + i*5] }
    @colors = @colors.map {|color_data| rgb(*color_data).swt_color}
    mandelbrot = Mandelbrot.new(@colors.size - 1)
    @y_array = (1.0).step(-1,-0.0030).to_a
    @x_array = (-2.0).step(0.5,0.0030).to_a
    @height = @y_array.size
    @width = @x_array.size
    @pixel_rows_array = mandelbrot.calculate_all(@x_array, @y_array)
  }


  body {
    shell {
      grid_layout
      text 'Mandelbrot Fractal'
      minimum_size @width, @height + 12
    
      label {
        'Scale'
      }
      spinner {
        selection bind(self, :scale_value, on_read: :to_i)
        
        on_key_pressed { |key_event|
          @canvas.redraw if key_event.keyCode == swt(:cr)
        }
      }
    
      @canvas = canvas {
        layout_data :fill, :fill, true, true
        on_paint_control { |e|
          e.gc.transform = scale_transform if scale_value.to_i > 0
          @height.times { |y|
            @width.times { |x|
              itr = @pixel_rows_array[y][x]
              e.gc.foreground = @colors[itr]
              e.gc.draw_point x, y
            }
          }
        }
      }
    }
  }
end

MandelbrotFractal.launch
