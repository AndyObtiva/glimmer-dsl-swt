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

# Mandelbrot implementation, borrowing some open-source code from:
# https://github.com/gotbadger/ruby-mandelbrot
# This version is multi-threaded, leveraging all processor cores.
class Mandelbrot
  DEFAULT_STEP = 0.0030
  
  attr_accessor :max_iterations

  def initialize(max_iterations)
    @max_iterations = max_iterations
  end
  
  def step_for(zoom)
    DEFAULT_STEP / zoom
  end
    
  def y_start
    -1.0
  end
  
  def y_end
    1.0
  end
  
  def y_array_for(zoom)
    y_start.step(y_end, step_for(zoom)).to_a
  end
  
  def x_start
    -2.0
  end
  
  def x_end
    0.5
  end
  
  def x_array_for(zoom)
    x_start.step(x_end, step_for(zoom)).to_a
  end
  
  def height_for(zoom)
    y_array_for(zoom).size
  end
  
  def width_for(zoom)
    x_array_for(zoom).size
  end
  
  def calculate_all(zoom)
    unless calculations.keys.include?(zoom)
      x_array = x_array_for(zoom)
      y_array = y_array_for(zoom)
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
      calculations[zoom] = pixel_rows_array
    end
    calculations[zoom]
  end
  
  def calculations
    @calculations ||= {}
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
    
  option :zoom, default: 1.0
  
  before_body {
    # precalculate mandelbrot image
    build_mandelbrot_image
  }
  
  body {
    shell(:no_resize) {
      text 'Mandelbrot Fractal'
      minimum_size width, height + 12
      image @mandelbrot_image
      
      @canvas = canvas {
        image @mandelbrot_image
        cursor :cross
        
        on_mouse_down { |mouse_event|
          if mouse_event.button == 1
            zoom_in
          elsif mouse_event.button > 2
            zoom_out
          end
        }
      }
    }
  }
  
  def build_mandelbrot_image
    pixels = mandelbrot.calculate_all(zoom)
#     @mandelbrot_image ||= image(width, height) TODO cache images for better performance
    @mandelbrot_image = image(width, height)
    height.times { |y|
      width.times { |x|
        new_foreground = color_palette[pixels[y][x]]
        @mandelbrot_image.gc.foreground = @current_foreground = new_foreground unless new_foreground == @current_foreground
        @mandelbrot_image.gc.draw_point x, y
      }
    }
    @mandelbrot_image
  end
  alias rebuild_mandelbrot_image build_mandelbrot_image
  
  def mandelbrot
    @mandelbrot ||= Mandelbrot.new(color_palette.size - 1)
  end
  
  def color_palette
    if @color_palette.nil?
      @color_palette = [[0, 0, 0]] + 40.times.map { |i| [255 - i*5, 255 - i*5, 55 + i*5] }
      @color_palette = @color_palette.map {|color_data| rgb(*color_data).swt_color}
    end
    @color_palette
  end
    
  def height
    mandelbrot.height_for(zoom)
  end
  
  def width
    mandelbrot.width_for(zoom)
  end
  
  def zoom_in
    perform_zoom(0.5)
  end
  
  def zoom_out
    perform_zoom(-0.5)
  end
  
  def perform_zoom(zoom_value)
    @canvas.cursor = :wait
    self.zoom = [self.zoom + zoom_value, 1.0].max
  #           @canvas.clear_shapes(dispose_images: false)
    @canvas.clear_shapes
    rebuild_mandelbrot_image
    body_root.content {
      # Update app icon
      image @mandelbrot_image
    }
    @canvas.content {
      image @mandelbrot_image
    }
    @canvas.redraw
    @canvas.cursor = :cross
  end
    
end

MandelbrotFractal.launch
