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
  end
  
  def calculate_all(x_array, y_array)
    thread_pool = Concurrent::FixedThreadPool.new(Concurrent.processor_count)
    width = x_array.size
    height = y_array.size
    pixel_rows_array = Concurrent::Array.new(height)
    height.times do |y|
      pixel_rows_array[y] ||= Concurrent::Array.new(width)
      width.times do |x|
        thread_pool.post do
          pixel_rows_array[y][x] = calculate(x_array[x], y_array[y]).last
        end
      end
    end
    thread_pool.shutdown
    thread_pool.wait_for_termination
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
    transform.scale(scale_value.to_f, scale_value.to_f).swt_transform
  end
  
  before_body {
    @scale_value = 1.0
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
        text 'Scale'
      }
      spinner {
        digits 1
        increment 5
        selection bind(
          self,
          :scale_value,
          on_read: ->(v) {v.to_f*10.0},
          on_write: ->(v) {v.to_f/10.0},
          after_write: ->() {@canvas.redraw}
        )
        
        on_key_pressed { |key_event|
          @canvas.redraw if key_event.keyCode == swt(:cr)
        }
      }
    
      @canvas = canvas {
        layout_data(:fill, :fill, true, true) {
          width_hint @width
          height_hint @height
        }
        
        # Consider double buffering with an image (so that resizing the window does not take time)
        on_paint_control { |paint_event|
          gc = paint_event.gc
          gc.transform = scale_transform if scale_value > 0 && scale_value != 1.0
          @height.times { |y|
            @width.times { |x|
              gc.foreground = @colors[@pixel_rows_array[y][x]]
              gc.draw_point x, y
            }
          }
        }
        
      }
    
    }
  }
end

MandelbrotFractal.launch
