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

require_relative 'piece'

class Quarto
  module View
    class AvailablePiecesArea
      include Glimmer::UI::CustomShape
      
      options :game
      
      body {
        rectangle(0, 0, PIECES_AREA_WIDTH, PIECES_AREA_HEIGHT) {
          background COLOR_WOOD
          
          text('Available Pieces', 15, 15) {
            font height: 18, style: :bold
          }
          
          x_offset = 15
          y_offset = 15 + 18 + 15
          x_spacing = 25
          y_spacing = 50
          row_count = 3
          column_count = 4
          row_count.times do |row|
            column_count.times do |column|
              piece(game: game, model: game.available_pieces[row*column_count + column], piece_x: x_offset + column*(View::Piece::SIZE + x_spacing), piece_y: y_offset + row*(View::Piece::SIZE + y_spacing))
            end
          end
        }
      }
    end
  end
end
