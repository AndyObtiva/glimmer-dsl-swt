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
require 'concurrent-ruby'

# Mandelbrot multi-threaded implementation leveraging all processor cores.
class Mandelbrot
  DEFAULT_STEP = 0.0030
  Y_START = -1.0
  Y_END = 1.0
  X_START = -2.0
  X_END = 0.5
  PROGRESS_MAX = 40
  
  class << self
    attr_accessor :progress, :work_in_progress
  
    def for(max_iterations:, zoom:, background: false)
      key = [max_iterations, zoom]
      creation_mutex.synchronize do
        unless flyweight_mandelbrots.keys.include?(key)
          flyweight_mandelbrots[key] = new(max_iterations: max_iterations, zoom: zoom, background: background)
        end
      end
      flyweight_mandelbrots[key].background = background
      flyweight_mandelbrots[key]
    end
    
    def flyweight_mandelbrots
      @flyweight_mandelbrots ||= {}
    end
    
    def creation_mutex
      @creation_mutex ||= Mutex.new
    end
  end
  
  attr_accessor :max_iterations, :background
  attr_reader :zoom, :points_calculated
  alias points_calculated? points_calculated
  
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
    @points ||= calculate_points
  end
  
  def thread_count
    # except on launch, shave two cores out for graphical user interface interaction and progress reporting to provide a better experience
    @background ? [Concurrent.processor_count - 2, 1].max : Concurrent.processor_count
  end
  
  def calculate_points
    puts "Background calculation activated at zoom #{zoom}" if @background
    if @points_calculated
      puts "Points calculated already. Returning previously calculated points..."
      return @points
    end
    thread_pool = Concurrent::FixedThreadPool.new(thread_count, fallback_policy: :discard)
    @points = Concurrent::Array.new(height)
    Mandelbrot.work_in_progress = "Calculating Mandelbrot Points for Zoom #{zoom}x"
    Mandelbrot.progress = 0
    point_index = 0
    point_count = width*height
    height.times do |y|
      @points[y] ||= Concurrent::Array.new(width)
      width.times do |x|
        thread_pool.post do
          @points[y][x] = calculate(x_array[x], y_array[y]).last
          point_index += 1
          Mandelbrot.progress += 1 if (point_index.to_f / point_count.to_f)*PROGRESS_MAX >= Mandelbrot.progress
        end
      end
    end
    thread_pool.shutdown
    thread_pool.wait_for_termination
    Mandelbrot.progress = PROGRESS_MAX
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
    
  COMMAND = OS.mac? ? :command : :ctrl
  
  attr_accessor :mandelbrot_shell_title
      
  option :zoom, default: 1.0
  
  before_body {
    Display.app_name = 'Mandelbrot Fractal'
    # pre-calculate mandelbrot image
    @mandelbrot_image = build_mandelbrot_image
  }
  
  after_body {
    observe(Mandelbrot, :work_in_progress) {
      update_mandelbrot_shell_title!
    }
    observe(Mandelbrot, :zoom) {
      update_mandelbrot_shell_title!
    }
    # pre-calculate zoomed mandelbrot images even before the user zooms in
    puts 'Starting background calculation thread...'
    Thread.new {
      future_zoom = 1.5
      loop {
        puts "Creating mandelbrot for background calculation at zoom: #{future_zoom}"
        the_mandelbrot = Mandelbrot.for(max_iterations: color_palette.size - 1, zoom: future_zoom, background: true)
        pixels = the_mandelbrot.calculate_points
        build_mandelbrot_image(mandelbrot_zoom: future_zoom)
        sync_exec {
          @canvas.cursor = :cross
        }
        future_zoom += 0.5
      }
    }
  }
  
  body {
    shell(:no_resize) {
      grid_layout
      text bind(self, :mandelbrot_shell_title, sync_exec: true)
      minimum_size mandelbrot.width + 29, mandelbrot.height + 77
      image @mandelbrot_image
      
      progress_bar {
        layout_data :fill, :center, true, false

        minimum 0
        maximum Mandelbrot::PROGRESS_MAX
        selection bind(Mandelbrot, :progress, sync_exec: true)
      }
          
      @scrolled_composite = scrolled_composite {
        layout_data :fill, :fill, true, true
        @canvas = canvas {
          image @mandelbrot_image
          cursor :no
          
          on_mouse_down {
            @drag_detected = false
            @canvas.cursor = :hand
          }
          
          on_drag_detected { |drag_detect_event|
            @drag_detected = true
            @drag_start_x = drag_detect_event.x
            @drag_start_y = drag_detect_event.y
          }
          
          on_mouse_move { |mouse_event|
            if @drag_detected
              origin = @scrolled_composite.origin
              new_x = origin.x - (mouse_event.x - @drag_start_x)
              new_y = origin.y - (mouse_event.y - @drag_start_y)
              @scrolled_composite.set_origin(new_x, new_y)
            end
          }
          
          on_mouse_up { |mouse_event|
            if !@drag_detected
              origin = @scrolled_composite.origin
              @location_x = [[origin.x + mouse_event.x - @scrolled_composite.bounds.width / 2.0, 0].max, @scrolled_composite.bounds.width].min
              @location_y = [[origin.y + mouse_event.y - @scrolled_composite.bounds.height / 2.0, 0].max, @scrolled_composite.bounds.height].min
              if mouse_event.button == 1
                zoom_in
              elsif mouse_event.button > 2
                zoom_out
              end
            end
            @canvas.cursor = can_zoom_in? ? :cross : :no
            @drag_detected = false
          }
          
        }
      }
      
      menu_bar {
        menu {
          text '&View'
          
          menu_item {
            text 'Zoom &In'
            accelerator COMMAND, '+'
            
            on_widget_selected { zoom_in }
          }
          
          menu_item {
            text 'Zoom &Out'
            accelerator COMMAND, '-'
            
            on_widget_selected { zoom_out }
          }
          
          menu_item {
            text '&Reset Zoom'
            accelerator COMMAND, '0'
            
            on_widget_selected { perform_zoom(mandelbrot_zoom: 1.0) }
          }
        }
        menu {
          text '&Help'
          
          menu_item {
            text '&Instructions'
            accelerator COMMAND, :shift, :i
            
            on_widget_selected {
              display_help_instructions
            }
          }
        }
      }
    }
  }
      
  def update_mandelbrot_shell_title!
    new_title = "Mandelbrot Fractal - Zoom #{zoom}x (Calculated Max: #{flyweight_mandelbrot_images.keys.max}x)"
    new_title += " - #{Mandelbrot.work_in_progress}" if Mandelbrot.work_in_progress
    self.mandelbrot_shell_title = new_title
  end
  
  def build_mandelbrot_image(mandelbrot_zoom: nil)
    mandelbrot_zoom ||= zoom
    unless flyweight_mandelbrot_images.keys.include?(mandelbrot_zoom)
      the_mandelbrot = mandelbrot(mandelbrot_zoom: mandelbrot_zoom)
      width = the_mandelbrot.width
      height = the_mandelbrot.height
      pixels = the_mandelbrot.points
      new_mandelbrot_image = image(width, height, top_level: true) # invoke as a top-level parentless keyword to avoid nesting under any widget
      new_mandelbrot_image_gc = new_mandelbrot_image.gc
      current_foreground = nil
      Mandelbrot.work_in_progress = "Consuming Points To Build Image for Zoom #{mandelbrot_zoom}x"
      Mandelbrot.progress = Mandelbrot::PROGRESS_MAX
      point_index = 0
      point_count = width*height
      height.times { |y|
        width.times { |x|
          new_foreground = color_palette[pixels[y][x]]
          new_mandelbrot_image_gc.foreground = current_foreground = new_foreground unless new_foreground == current_foreground
          new_mandelbrot_image_gc.draw_point x, y
          point_index += 1
          Mandelbrot.progress -= 1 if (Mandelbrot::PROGRESS_MAX - (point_index.to_f / point_count.to_f)*Mandelbrot::PROGRESS_MAX) < Mandelbrot.progress
        }
      }
      Mandelbrot.progress = 0
      flyweight_mandelbrot_images[mandelbrot_zoom] = new_mandelbrot_image
      update_mandelbrot_shell_title!
    end
    flyweight_mandelbrot_images[mandelbrot_zoom]
  end
  
  def flyweight_mandelbrot_images
    @flyweight_mandelbrot_images ||= {}
  end
  
  def mandelbrot(mandelbrot_zoom: nil)
    mandelbrot_zoom ||= zoom
    Mandelbrot.for(max_iterations: color_palette.size - 1, zoom: mandelbrot_zoom)
  end
  
  def color_palette
    if @color_palette.nil?
      @color_palette = [[0, 0, 0]] + 40.times.map { |i| [255 - i*5, 255 - i*5, 55 + i*5] }
      @color_palette = @color_palette.map {|color_data| rgb(*color_data).swt_color}
    end
    @color_palette
  end
    
  def zoom_in
    if can_zoom_in?
      perform_zoom(zoom_delta: 0.5)
      @canvas.cursor = can_zoom_in? ? :cross : :no
    end
  end
  
  def can_zoom_in?
    flyweight_mandelbrot_images.keys.include?(zoom + 0.5)
  end
  
  def zoom_out
    perform_zoom(zoom_delta: -0.5)
  end
  
  def perform_zoom(zoom_delta: 0, mandelbrot_zoom: nil)
    mandelbrot_zoom ||= self.zoom + zoom_delta
    @canvas.cursor = :wait
    last_zoom = self.zoom
    self.zoom = [mandelbrot_zoom, 1.0].max
    @canvas.clear_shapes(dispose_images: false)
    @mandelbrot_image = build_mandelbrot_image
    body_root.content {
      image @mandelbrot_image
    }
    @canvas.content {
      image @mandelbrot_image
    }
    @canvas.set_size @mandelbrot_image.bounds.width, @mandelbrot_image.bounds.height
    @scrolled_composite.swt_widget.set_min_size(Point.new(@mandelbrot_image.bounds.width, @mandelbrot_image.bounds.height))
    if @location_x && @location_y
      factor = (zoom / last_zoom)
      @scrolled_composite.set_origin(factor*@location_x, factor*@location_y)
      @location_x = @location_y = nil
    end
    update_mandelbrot_shell_title!
    @canvas.cursor = :cross
  end
  
  def display_help_instructions
    message_box(body_root) {
      text 'Mandelbrot Fractal - Help'
      message <<~MULTI_LINE_STRING
        The Mandelbrot Fractal precalculates zoomed renderings in the background. Wait if you hit a zoom level that is not calculated yet.

        Left-click to zoom in.
        Right-click to zoom out.
        Scroll or drag to pan.
        
        Enjoy!
      MULTI_LINE_STRING
    }.open
  end
    
end

MandelbrotFractal.launch
