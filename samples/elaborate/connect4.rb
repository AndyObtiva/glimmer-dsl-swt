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

class Connect4
  include Glimmer::UI::CustomShell
  
  COLOR_BACKGROUND = rgb(63, 104, 212)
  COLOR_EMPTY_SLOT = :white
  COLOR_COIN1 = rgb(236, 223, 56)
  COLOR_COIN2 = rgb(176, 11, 23)
  
  body {
    shell {
      grid_layout(7, true)

      text 'Glimmer Connect 4'
      background COLOR_BACKGROUND
      
      6.times.map do |row_index|
        7.times.map do |column_index|
          canvas {
            layout_data {
              width_hint 50
              height_hint 50
            }
            
            background :transparent
            
            an_oval = oval(0, 0, 50, 50) {
              background COLOR_EMPTY_SLOT
            }
            
            if row_index == 0
              on_mouse_enter do
                an_oval.background = COLOR_COIN1
              end
              
              on_mouse_exit do
                an_oval.background = COLOR_EMPTY_SLOT
              end
            end
          }
        end
      end
    }
  }
end

Connect4.launch
