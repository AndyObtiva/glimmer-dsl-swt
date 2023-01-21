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

require_relative 'piece'

class Quarto
  module View
    class AvailablePiecesArea
      include Glimmer::UI::CustomShape
      
      options :game
      option :location_x, default: 0
      option :location_y, default: 0
      
      attr_reader :pieces
      
      after_body do
        reset_pieces
      end
      
      body {
        rectangle(location_x, location_y, PIECES_AREA_WIDTH, AVAILABLE_PIECES_AREA_HEIGHT) {
          background COLOR_WOOD
          
          rectangle(0, 0, :max, :max, round: true) { # border
            foreground :black
            line_width 2
          }
          
          text('Available Pieces', 15, 10) {
            font height: 18, style: :bold
          }
        }
      }
      
      def reset_pieces
        @pieces&.dup&.each { |piece| piece.dispose(redraw: false) }
        body_root.content {
          x_offset = 15
          y_offset = 10 + 18 + 10
          x_spacing = 10
          y_spacing = 35
          row_count = 3
          column_count = 4
          @pieces = row_count.times.map do |row|
            column_count.times.map do |column|
              piece(game: game, model: game.available_pieces[row*column_count + column], location_x: x_offset + column*(View::Piece::BASIC_SHAPE_WIDTH + x_spacing), location_y: y_offset + row*(View::Piece::SIZE_TALL + y_spacing))
            end
          end.flatten
        }
      end
    end
  end
end
