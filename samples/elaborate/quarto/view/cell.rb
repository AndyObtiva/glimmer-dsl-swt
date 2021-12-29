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

class Quarto
  module View
    class Cell
      include Glimmer::UI::CustomShape
      
      options :game, :row, :column
      
      before_body do
        @board_x_offset = (BOARD_DIAMETER - COLUMN_COUNT * (CELL_DIAMETER + CELL_LINE_WIDTH + CELL_MARGIN) + CELL_LINE_WIDTH + CELL_MARGIN) / 2.0
        @board_y_offset = (BOARD_DIAMETER - ROW_COUNT * (CELL_DIAMETER + CELL_LINE_WIDTH + CELL_MARGIN) + CELL_LINE_WIDTH + CELL_MARGIN) / 2.0
      end
      
      body {
        oval(@board_x_offset + column * (CELL_DIAMETER + CELL_LINE_WIDTH + CELL_MARGIN),
             @board_y_offset + row * (CELL_DIAMETER + CELL_LINE_WIDTH + CELL_MARGIN),
             CELL_DIAMETER,
             CELL_DIAMETER) {
          background :black
          line_width CELL_LINE_WIDTH
          transform board_rotation_transform
          
          oval { # this draws an outline around max dimensions by default (when no x,y,w,h specified)
            foreground COLOR_WOOD
            line_width CELL_LINE_WIDTH
            transform board_rotation_transform
          }
          
          on_drop do |drop_event|
            dragged_piece = drop_event.dragged_shape
            return drop_event.doit = false unless dragged_piece.parent.get_data('custom_shape').is_a?(SelectedPieceArea)
            model = dragged_piece.get_data('custom_shape').model
            dragged_piece.parent.shapes.delete(dragged_piece)
            body_root.content {
              # TODO fix issue with unnecessary rotation
              @selected_piece = piece(game: game, model: model, location_x: 10, location_y: -10) {
                transform {
                  translate (SHELL_MARGIN + BOARD_DIAMETER)/2.0, (SHELL_MARGIN + BOARD_DIAMETER)/2.0
                  rotate 45
                  translate -(SHELL_MARGIN + BOARD_DIAMETER)/2.0, -(SHELL_MARGIN + BOARD_DIAMETER)/2.0
                  
                  # extra translation to improve location of rotated cells
                  translate 7, -6
                }
              }
            }
            game.place_piece(model, row: row, column: column)
          end
        }
      }
      
      def board_rotation_transform
        @board_rotation_transform ||= transform {
          # main rotation is done by moving shape to be centered in origin, rotating, and then moving shape back
          translate (SHELL_MARGIN + BOARD_DIAMETER)/2.0, (SHELL_MARGIN + BOARD_DIAMETER)/2.0
          rotate 45
          translate -(SHELL_MARGIN + BOARD_DIAMETER)/2.0, -(SHELL_MARGIN + BOARD_DIAMETER)/2.0
          
          # extra translation to improve location of rotated cells
          translate 7, -4
        }
      end
    end
  end
end
