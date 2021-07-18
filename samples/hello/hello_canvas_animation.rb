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
require 'bigdecimal'

class HelloCanvasAnimation
  include Glimmer::UI::CustomShell
  
  # data-bindable attributes (names must vary from attribute names on animation)
  attr_accessor :animation_every, :animation_frame_count, :animation_started, :animation_finished
  
  before_body {
    @animation_every = 0.050
    @animation_frame_count = 100
    @animation_started = true
    @animation_finished = false
  }
  
  body {
    shell {
      grid_layout(2, true)
      text 'Hello, Canvas Animation!'
      
      button {
        layout_data(:fill, :center, true, false)
        text <= [self, :animation_started, on_read: ->(value) { value ? 'Stop' : 'Resume' }]
        enabled <= [self, :animation_finished, on_read: :!]
        
        on_widget_selected do
          if @animation.started?
            @animation.stop
          else
            @animation.start
          end
        end
      }
      button {
        layout_data(:fill, :center, true, false)
        text 'Restart'
        
        on_widget_selected do
          @animation.restart
        end
      }
      label {
        text 'every (milliseconds)'
      }
      label {
        text 'frame count (0 is unlimited)'
      }
      spinner {
        layout_data(:fill, :center, true, false)
        digits 3
        minimum 1
        maximum 100
        selection <=> [self, :animation_every, on_read: ->(v) {(BigDecimal(v.to_s)*1000).to_f}, on_write: ->(v) {(BigDecimal(v.to_s)/1000).to_f}]
      }
      spinner {
        layout_data(:fill, :center, true, false)
        minimum 0
        maximum 100
        selection <=> [self, :animation_frame_count]
      }
      
      canvas {
        layout_data(:fill, :fill, true, true) {
          horizontal_span 2
          width_hint 320
          height_hint 320
        }
        @animation = animation {
          every <= [self, :animation_every]
          frame_count <= [self, :animation_frame_count]
          started <=> [self, :animation_started]
          finished <=> [self, :animation_finished]
          
          frame { |index|
            background rgb(index%100, index%100 + 100, index%55 + 200)
            oval(index*3%300, index*3%300, 20, 20) {
              background :yellow
            }
          }
        }
      }
    }
  }
end

HelloCanvasAnimation.launch
