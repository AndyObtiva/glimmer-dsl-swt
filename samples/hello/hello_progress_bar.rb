# Copyright (c) 2007-2024 Andy Maleh
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

class HelloProgressBar
  include Glimmer::UI::CustomShell
  
  class ProgressModel
    attr_accessor :minimum, :maximum, :selection, :delay
  end
        
  before_body do
    @progress_model = ProgressModel.new
    @progress_model.minimum = 0
    @progress_model.maximum = 100
    @progress_model.selection = 0
    @progress_model.delay = 0.01
  end

  body {
    shell {
      grid_layout(4, true)
      
      text 'Hello, Progress Bar!'
      
      progress_bar(:indeterminate) {
        layout_data(:fill, :center, true, false) {
          horizontal_span 4
        }
      }
      
      label {
        text 'Minimum'
      }
      
      label {
        text 'Maximum'
      }
      
      label {
        text 'Selection'
      }
      
      label {
        text 'Delay in Seconds'
      }
      
      spinner {
        selection <=> [@progress_model, :minimum]
      }
      
      spinner {
        selection <=> [@progress_model, :maximum]
      }
      
      spinner {
        selection <=> [@progress_model, :selection]
      }
        
      spinner {
        digits 2
        minimum 1
        maximum 200
        selection <=> [@progress_model, :delay, on_read: ->(v) {v.to_f*100.0}, on_write: ->(v) {v.to_f/100.0}]
      }
          
      progress_bar {
        layout_data(:fill, :center, true, false) {
          horizontal_span 4
        }
        minimum <= [@progress_model, :minimum]
        maximum <= [@progress_model, :maximum]
        selection <= [@progress_model, :selection]
      }
      
      progress_bar(:vertical) {
        layout_data(:fill, :center, true, false) {
          horizontal_span 4
        }
        minimum <= [@progress_model, :minimum]
        maximum <= [@progress_model, :maximum]
        selection <= [@progress_model, :selection]
      }
      
      button {
        layout_data(:fill, :center, true, false) {
          horizontal_span 4
        }
        text "Start"
        
        on_widget_selected do
          # if a previous thread is running, then kill first
          # (killing is not dangerous since it is only a thread about updating progress)
          @current_thread&.kill
          @current_thread = Thread.new do
            @progress_model.selection = @progress_model.minimum
            (@progress_model.minimum..@progress_model.maximum).to_a.each do |n|
              @progress_model.selection = n
              sleep(@progress_model.delay)
            end
          end
        end
      }
    }
  }
end

HelloProgressBar.launch
