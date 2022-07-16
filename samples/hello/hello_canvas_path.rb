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

class HelloCanvasPath
  include Glimmer::UI::Application
    
  after_body do
    regenerate
  end
  
  body {
    shell {
      grid_layout {
        margin_width 0
        margin_height 0
        margin_top 5
      }
      
      text 'Hello, Canvas Path!'
      minimum_size 800, 700
      
      @button = button {
        layout_data :center, :center, true, false
        
        text 'Regenerate'
        enabled false
        
        on_widget_selected do
          regenerate
        end
      }
      
      canvas {
        layout_data :fill, :fill, true, true
        background :white
        
        text('line', 15, 200) {
          foreground :red
        }
        @path1 = path {
          antialias :on
          foreground :red
        }
        
        text('quad', 15, 300) {
          foreground :dark_green
        }
        @path2 = path {
          antialias :on
          foreground :dark_green
        }
        
        text('cubic', 15, 400) {
          foreground :blue
        }
        @path3 = path {
          antialias :on
          foreground :blue
        }
      }
      
      on_widget_disposed do
        # safe to kill thread as data is in memory only, so no risk of data loss
        @thread.kill
      end
    }
  }
  
  def regenerate
    @thread = Thread.new do
      @button.enabled = false
      @path1.clear
      @path2.clear
      @path3.clear
      y1 = y2 = y3 = 300
      700.times.each do |x|
        x += 55
        x1 = x - 2
        x2 = x - 1
        x3 = x
        y1 = y3
        y2 = y1
        y3 = [[y3 + (rand*24 - 12), 0].max, 700].min
        @path1.content {
          line(x1, y1 - 100)
        }
        if x % 2 == 0
          @path2.content {
            quad(x1, y1, x2, y2)
          }
        end
        if x % 3 == 0
          @path3.content {
            cubic(x1, y1 + 100, x2, y2 + 100, x3, y3 + 100)
          }
        end
        sleep(0.01)
      end
      @button.enabled = true
    end
  end
end
        
HelloCanvasPath.launch
