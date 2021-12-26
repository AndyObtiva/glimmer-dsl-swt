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

class Quarto
  include Glimmer::UI::CustomShell
  
  BOARD_WIDTH = 430
  BOARD_HEIGHT = BOARD_WIDTH
  
  body {
    shell {
      text 'Glimmer Quarto'
      minimum_size BOARD_WIDTH, BOARD_HEIGHT + 24
      maximum_size BOARD_WIDTH, BOARD_HEIGHT + 24
      
      rectangle(0, 0, BOARD_WIDTH, BOARD_HEIGHT) {
        background :black
        
        oval {
          foreground rgb(239, 196, 156)
          line_width 5
          
#           7.times do |row|
#             columns = row <= 3 ? row + 1 : (7 - row)
#             column.times do |column|
#
#             end
#           end
        }
      }
    }
  }
end

Quarto.launch
