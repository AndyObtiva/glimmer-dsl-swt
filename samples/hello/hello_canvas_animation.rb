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
  
  attr_accessor :animation_every, :animation_fps, :animation_frame_count, :animation_duration_limit, :animation_started, :animation_finished
  
  before_body {
    @animation_every = 0.050 # seconds
    @animation_fps = 0
    @animation_frame_count = 100
    @animation_duration_limit = 0 # seconds
    @animation_started = true
    @animation_finished = false
  }
  
  body {
    shell {
      grid_layout(2, true)
      text 'Hello, Canvas Animation!'
      
      # row 1
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

      # row 2
      label {
        text 'every'
      }
      label {
        text 'frames per second'
      }
      
      # row 3
      spinner {
        layout_data(:fill, :center, true, false)
        digits 3
        minimum 0
        maximum 100
        selection <=> [self, :animation_every, on_read: ->(v) {(BigDecimal(v.to_s)*1000).to_f}, on_write: ->(v) {(BigDecimal(v.to_s)/1000).to_f}]
      }
      spinner {
        layout_data(:fill, :center, true, false)
        minimum 0
        maximum 100
        selection <=> [self, :animation_fps]
      }
      
      # row 4
      label {
        text 'frame count (0=unlimited)'
      }
      label {
        text 'duration limit (0=unlimited)'
      }
      
      # row 5
      spinner {
        layout_data(:fill, :center, true, false)
        minimum 0
        maximum 100
        selection <=> [self, :animation_frame_count]
      }
      spinner {
        layout_data(:fill, :center, true, false)
        minimum 0
        maximum 10
        selection <=> [self, :animation_duration_limit]
      }
      
      canvas {
        layout_data(:fill, :fill, true, true) {
          horizontal_span 2
          width_hint 320
          height_hint 320
        }
        @animation = animation {
          every          <=  [self, :animation_every]
          fps            <=  [self, :animation_fps]
          frame_count    <=  [self, :animation_frame_count]
          duration_limit <=  [self, :animation_duration_limit]
          started        <=> [self, :animation_started]
          finished       <=> [self, :animation_finished]
          
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
  
  def animation_every=(value)
    @animation_every = value
    self.animation_fps = 0 if @animation_every.to_f > 0
  end
  
  def animation_fps=(value)
    @animation_fps = value
    self.animation_every = 0 if @animation_fps.to_f > 0
  end
end

HelloCanvasAnimation.launch
