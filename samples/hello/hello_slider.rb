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

class HelloScale
  include Glimmer::UI::CustomShell
  
  attr_accessor :value
  
  before_body do
    @value = 50
  end
  
  body {
    shell {
      row_layout(:vertical) {
        fill true
        center true
      }
      
      text 'Hello, Slider!'
      
      label(:center) {
        text <= [self, :value]
      }
      
      slider { # optionally takes :vertical or :horizontal (default) SWT style
        minimum 0
        maximum 110 # leave room for 10 extra (slider stops at 100)
        page_increment 10 # page increment occurs when clicking area between slider and beginning or end
        selection <=> [self, :value]
      }
        
    }
    
  }
end

HelloScale.launch
