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

# require_relative 'piece'

class Quarto
  module View
    class SelectedPieceArea
      include Glimmer::UI::CustomShape
      
      options :game
      option :location_x, default: 0
      option :location_y, default: 0
      
      attr_reader :selected_piece
      
      body {
        rectangle(location_x, location_y, PIECES_AREA_WIDTH, SELECTED_PIECE_AREA_HEIGHT) {
          background COLOR_WOOD
          
          rectangle(0, 0, :max, :max, round: true) { # border
            foreground :black
            line_width 2
          }
          
          text('Selected Piece', 15, 10) {
            font height: 18, style: :bold
          }
          
          on_drop do |drop_event|
            dragged_piece = drop_event.dragged_shape
            if dragged_piece.parent.get_data('custom_shape').is_a?(AvailablePiecesArea)
              model = dragged_piece.get_data('custom_shape').model
              dragged_piece.dispose
              body_root.content {
                @selected_piece = piece(game: game, model: model, location_x: 15, location_y: 15 + 25)
              }
              game.select_piece(model)
            else
              drop_event.doit = false
            end
          end
        }
      }
      
      def reset_selected_piece
        @selected_piece&.dispose
      end
    end
  end
end
