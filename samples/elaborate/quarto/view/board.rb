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

require_relative 'cell'

class Quarto
  module View
    class Board
      include Glimmer::UI::CustomShape
      
      option :location_x, default: 0
      option :location_y, default: 0
      
      body {
        rectangle(location_x, location_y, BOARD_DIAMETER, BOARD_DIAMETER, round: true) {
          background :black
          
          text("Glimmer\nQuarto", BOARD_DIAMETER - 69, BOARD_DIAMETER - 43) {
            foreground COLOR_WOOD
          }
          
          oval(0, 0, :max, :max) {
            foreground COLOR_WOOD
            line_width CELL_LINE_WIDTH
            
            ROW_COUNT.times do |row|
              COLUMN_COUNT.times do |column|
                cell(row: row, column: column)
              end
            end
          }
        }
      }
      
      def board_rotation_transform
        @board_rotation_transform ||= transform {
          translate BOARD_DIAMETER/2.0, BOARD_DIAMETER/2.0
          rotate 45
          translate -BOARD_DIAMETER/2.0, -BOARD_DIAMETER/2.0
        }
      end
    end
  end
end
