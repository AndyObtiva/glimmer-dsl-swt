# Copyright (c) 2007-2022 Andy Maleh
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

class HelloCanvas
  include Glimmer::UI::CustomShell
  
  attr_accessor :selected_shape
  attr_accessor :artist
  
  before_body do
    @image_object = image(File.expand_path('../../icons/scaffold_app.png', __dir__), width: 50)
    @artist = ''
  end
  
  after_body do
    Thread.new do
      'Picasso'.chars.each do |character|
        sleep(1)
        self.artist += character
      end
    end
  end
  
  body {
    shell {
      text 'Hello, Canvas!'
      minimum_size 320, 400
    
      @canvas = canvas {
        background :yellow
        
        rectangle(0, 0, 220, 400) {
          background rgb(255, 0, 0)
        }
        rectangle(50, 20, 300, 150, 30, 50) {
          background :magenta
          rectangle(:default, :default, :max, :max, 30, 50) {
            foreground :yellow
          }
          rectangle([:default, -70], :default, :default, [:default, 1]) {
            foreground :cyan
            text {
              string <= [self, :artist]
              x :default, 1 # add 1 pixel to default x (shape centered within parent horizontally)
              y :default, 1 # add 1 pixel to default y (shape centered within parent vertically)
              background :yellow
              foreground :dark_magenta
              font name: 'Courier', height: (OS.windows? ? 26 : 30)
            }
          }
          rectangle(155, 30) { # width and height are assumed to be the default (calculated from children)
            foreground :yellow
            3.times do |n|
              line(45, 70 + n*10, 65 + n*10, 30 + n*10) {
                foreground :yellow
              }
            end
            10.times do |n|
              point(15 + n*5, 50 + n*5) {
                foreground :yellow
              }
            end
            polyline(45, 60, 55, 20, 65, 60, 85, 80, 45, 60)
            image(@image_object, 0, 5)
          }
        }
        rectangle(150, 200, 100, 70, true) {
          background :dark_magenta
          foreground :yellow
        }
        rectangle(50, 200, 30, 70, false) {
          background :magenta
          foreground :dark_blue
        }
        oval(110, 310, 100, 100) {
          # patterns provide a differnet way to make gradients
          background_pattern 0, 0, 105, 0, :yellow, rgb(128, 138, 248)
        }
        arc(210, 210, 100, 100, 30, -77) {
          background :red
        }
        polygon(250, 210, 260, 170, 270, 210, 290, 230) {
          background :dark_yellow
        }
      
        menu {
          menu_item {
            text 'Change Background Color...'
            enabled <=> [self, :selected_shape, on_read: ->(shape) { shape.respond_to?(:background) && shape.background }]
            on_widget_selected do
              @selected_shape&.background = color_dialog.open
              self.selected_shape = nil
            end
          }
          menu_item {
            text 'Change Background Pattern Color 1...'
            enabled <=> [self, :selected_shape, on_read: ->(shape) { shape.respond_to?(:background_pattern) && shape.background_pattern }]
            on_widget_selected do
              if @selected_shape
                background_pattern_args = @selected_shape.background_pattern_args
                background_pattern_args[5] = color_dialog.open
                @selected_shape.background_pattern = background_pattern_args
                self.selected_shape = nil
              end
            end
          }
          menu_item {
            text 'Change Background Pattern Color 2...'
            enabled <=> [self, :selected_shape, on_read: ->(shape) { shape.respond_to?(:background_pattern) && shape.background_pattern }]
            on_widget_selected do
              if @selected_shape
                background_pattern_args = @selected_shape.background_pattern_args
                background_pattern_args[6] = color_dialog.open
                @selected_shape.background_pattern = background_pattern_args
                self.selected_shape = nil
              end
            end
          }
          menu_item(:separator)
          menu_item {
            text 'Change Foreground Color...'
            enabled <=> [self, :selected_shape, on_read: ->(shape) { shape.respond_to?(:foreground) && shape.foreground }]
            on_widget_selected do
              @selected_shape&.foreground = color_dialog.open
              self.selected_shape = nil
            end
          }
        }
      
        on_mouse_down do |mouse_event|
          @drag_detected = false
          @canvas.cursor = :hand
          self.selected_shape = @canvas.shape_at_location(mouse_event.x, mouse_event.y)
        end
        
        on_drag_detected do |drag_detect_event|
          @drag_detected = true
          @drag_current_x = drag_detect_event.x
          @drag_current_y = drag_detect_event.y
        end
        
        on_mouse_move do |mouse_event|
          if @drag_detected
            @selected_shape&.move_by(mouse_event.x - @drag_current_x, mouse_event.y - @drag_current_y)
            @drag_current_x = mouse_event.x
            @drag_current_y = mouse_event.y
          end
        end
        
        on_menu_detected do |menu_detect_event|
          @menu_detected = true
        end
        
        on_mouse_up do |mouse_event|
          @canvas.cursor = :arrow
          @drag_detected = false
          if @menu_detected
            @menu_detected = nil
          else
            self.selected_shape = nil
          end
        end
      }
    }
  }
end

HelloCanvas.launch
        
