# Copyright (c) 2007-2023 Andy Maleh
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

include Glimmer

shell {
  grid_layout {
    margin_width 0
    margin_height 0
  }
  
  text 'Hello, Scrolled Composite!'
  maximum_size 400, 400
  
  composite {
    layout_data {
      horizontal_alignment :center
    }
    
    row_layout
    
    button {
      text '<<'
      
      on_widget_selected do
        @scrolled_composite.set_origin(0, @scrolled_composite.origin.y)
      end
    }
    
    button {
      text '>>'
      
      on_widget_selected do
        @scrolled_composite.set_origin(@inner_composite.size.x, @scrolled_composite.origin.y)
      end
    }
    
    button {
      text '^^'
      
      on_widget_selected do
        @scrolled_composite.set_origin(@scrolled_composite.origin.x, 0)
      end
    }
    
    button {
      text 'vv'
      
      on_widget_selected do
        @scrolled_composite.set_origin(@scrolled_composite.origin.x, @inner_composite.size.y)
      end
    }
  }

  @scrolled_composite = scrolled_composite {
    layout_data :fill, :fill, true, true
    
    @inner_composite = composite {
      row_layout(:vertical)
      
      background :white

      50.times do |n|
        label {
          layout_data {
            height 20
          }
          
          text "Line #{n+1} has a lot of gibberish in it. In fact, it has so much gibberish that it does not fit the window horizontally, so scrollbars must be used to see all the text."
          background :white
        }
      end
    }
  }
}.open
