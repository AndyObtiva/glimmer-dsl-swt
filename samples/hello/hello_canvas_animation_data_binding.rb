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

class HelloAnimationDataBinding
  include Glimmer::UI::CustomShell
  
  attr_accessor :delay_time
  
  before_body {
    @delay_time = 0.050
  }
  
  body {
    shell {
      text 'Hello, Canvas Animation Data Binding!'
      minimum_size 320, 320
      
      canvas {
        grid_layout
        
        spinner {
          layout_data(:center, :center, true, true) {
            minimum_width 75
          }
          digits 3
          minimum 1
          maximum 100
          selection bind(self, :delay_time, on_read: ->(v) {(BigDecimal(v.to_s)*1000).to_f}, on_write: ->(v) {(BigDecimal(v.to_s)/1000).to_f})
        }
        animation {
          every bind(self, :delay_time)
          
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

HelloAnimationDataBinding.launch
