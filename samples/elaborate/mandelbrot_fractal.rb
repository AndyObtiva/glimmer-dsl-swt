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

# Mandelbrot multi-threaded implementation leveraging all processor cores.
class Mandelbrot
  DEFAULT_STEP = 0.0030
  Y_START = -1.0
  Y_END = 1.0
  X_START = -2.0
  X_END = 0.5
  
  class << self
    def for(max_iterations:, zoom:, background: false)
      key = [max_iterations, zoom]
      @for_mutex ||= Mutex.new
      @for_mutex.synchronize do
        unless flyweight_mandelbrots.keys.include?(key)
          flyweight_mandelbrots[key] = new(max_iterations: max_iterations, zoom: zoom, background: background)
        end
      end
      flyweight_mandelbrots[key]
    end
    
    def flyweight_mandelbrots
      @flyweight_mandelbrots ||= {}
    end
  end
  
  attr_accessor :max_iterations
  attr_reader :zoom
  
  # max_iterations is the maximum number of Mandelbrot calculation iterations
  # zoom is how much zoom there is on the Mandelbrot points from the default view of zoom 1
  # background indicates whether to do calculation in the background for caching purposes,
  # thus utilizing less CPU cores to avoid disrupting user experience
  def initialize(max_iterations:, zoom: 1.0, background: false)
    @max_iterations = max_iterations
    @zoom = zoom
    @background = background
  end
  
  def step
    DEFAULT_STEP / zoom
  end
    
  def y_array
    @y_array ||= Y_START.step(Y_END, step).to_a
  end
  
  def x_array
    @x_array ||= X_START.step(X_END, step).to_a
  end
  
  def height
    y_array.size
  end
  
  def width
    x_array.size
  end
  
  def points
    @points = calculate_points if @points.nil? || !@points_calculated
  end
  
  def calculate_points
    thread_count = @background ? [Concurrent.processor_count - 2, 1].max : Concurrent.processor_count
    # TODO shut down previous thread pool if exists
    thread_pool = Concurrent::FixedThreadPool.new(thread_count)
    @points ||= Concurrent::Array.new(height)
    height.times do |y|
      @points[y] ||= Concurrent::Array.new(width)
      width.times do |x|
        if @points[y][x].nil?
          thread_pool.post do
            @points[y][x] = calculate(x_array[x], y_array[y]).last
          end
        end
      end
    end
    thread_pool.shutdown
    thread_pool.wait_for_termination
    @points_calculated = true
    @points
  end
  
  # Calculates a Mandelbrot point, borrowing some open-source code from:
  # https://github.com/gotbadger/ruby-mandelbrot
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
    # pre-calculate mandelbrot image
    build_mandelbrot_image
  }
  
  after_body {
    # pre-calculate zoomed mandelbrot images even before the user zooming
#     Thread.new {
#       loop {
#         mandelbrot.zoom
#       }
#     }
  }
  
  body {
    shell(:no_resize) {
      text 'Mandelbrot Fractal'
      minimum_size width, height + 12
      image @mandelbrot_image
      
      @scrolled_composite = scrolled_composite {
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
  }
  
  def build_mandelbrot_image
    unless flyweight_mandelbrot_images.keys.include?(zoom)
      pixels = mandelbrot.points
      @mandelbrot_image = image(width, height)
      height.times { |y|
        width.times { |x|
          new_foreground = color_palette[pixels[y][x]]
          @mandelbrot_image.gc.foreground = @current_foreground = new_foreground unless new_foreground == @current_foreground
          @mandelbrot_image.gc.draw_point x, y
        }
      }
      flyweight_mandelbrot_images[zoom] = @mandelbrot_image
    end
    @mandelbrot_image = flyweight_mandelbrot_images[zoom]
  end
  
  def flyweight_mandelbrot_images
    @flyweight_mandelbrot_images ||= {}
  end
  
  def mandelbrot
    Mandelbrot.for(max_iterations: color_palette.size - 1, zoom: zoom)
  end
  
  def color_palette
    if @color_palette.nil?
      @color_palette = [[0, 0, 0]] + 40.times.map { |i| [255 - i*5, 255 - i*5, 55 + i*5] }
      @color_palette = @color_palette.map {|color_data| rgb(*color_data).swt_color}
    end
    @color_palette
  end
    
  def height
    mandelbrot.height
  end
  
  def width
    mandelbrot.width
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
    @canvas.clear_shapes(dispose_images: false)
    build_mandelbrot_image
    body_root.content {
      image @mandelbrot_image
    }
    @canvas.content {
      image @mandelbrot_image
    }
    @canvas.set_size @mandelbrot_image.bounds.width, @mandelbrot_image.bounds.height
    @scrolled_composite.swt_widget.set_min_size(Point.new(@mandelbrot_image.bounds.width, @mandelbrot_image.bounds.height))
    @canvas.cursor = :cross
  end
    
end

MandelbrotFractal.launch
