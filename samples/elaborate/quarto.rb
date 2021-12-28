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

require_relative 'quarto/model/game'
require_relative 'quarto/view/board'
require_relative 'quarto/view/available_pieces_area'
require_relative 'quarto/view/selected_piece_area'
require_relative 'quarto/view/message_box_panel'

class Quarto
  include Glimmer::UI::CustomShell
  
  BOARD_DIAMETER = 430
  PIECES_AREA_WIDTH = 252
  AVAILABLE_PIECES_AREA_HEIGHT = 295
  SELECTED_PIECE_AREA_HEIGHT = 124
  CELL_DIAMETER = 68
  CELL_LINE_WIDTH = 5
  CELL_MARGIN = 7
  SHELL_MARGIN = 15
  AREA_MARGIN = 10
  ROW_COUNT = 4
  COLUMN_COUNT = 4
  COLOR_WOOD = rgb(239, 196, 156)
  COLOR_AREA = rgb(206, 188, 170)
  COLOR_LIGHT_WOOD = rgb(254, 187, 120)
  COLOR_DARK_WOOD = rgb(204, 108, 58)
  MESSAGE_BOX_PANEL_WIDTH = 300
  MESSAGE_BOX_PANEL_HEIGHT = 100
  
  before_body do
    @game = Model::Game.new
    
#     observe(@game, :expected_move) do |new_expected_move|
#       body_root.content {
#         message_box_panel_x = (body_root.size.x - MESSAGE_BOX_PANEL_WIDTH) / 2.0
#         message_box_panel_y = (body_root.size.y - MESSAGE_BOX_PANEL_HEIGHT) / 2.0
#         @message_box_panel = rectangle(message_box_panel_x, message_box_panel_y, MESSAGE_BOX_PANEL_WIDTH, MESSAGE_BOX_PANEL_HEIGHT, round: true) {
#           verbiage = case new_expected_move
#           when :select_piece
#             "Player #{@game.current_player} must select a piece for the other player to place on the board!"
#           when :place_piece
#             "Player #{@game.current_player} must place the selected piece on the board!"
#           end
#           text(verbiage, :center, :center)
#         }
#       }
#       sleep(2)
#       @message_box_panel.destroy
#     end
  end
  
  after_body do
    # TODO delete this, it is just a test
    body_root.content {
      message_box_panel(
        message: "Player 1 must select a piece for the\n other player to place on the board!",
        background_color: COLOR_LIGHT_WOOD,
        text_font: {height: 16}
      )
    }
  end

  body {
    shell {
      text 'Glimmer Quarto'
      minimum_size BOARD_DIAMETER + AREA_MARGIN + PIECES_AREA_WIDTH + SHELL_MARGIN*2, BOARD_DIAMETER + 24 + SHELL_MARGIN*2
      maximum_size BOARD_DIAMETER + AREA_MARGIN + PIECES_AREA_WIDTH + SHELL_MARGIN*2, BOARD_DIAMETER + 24 + SHELL_MARGIN*2
      background COLOR_WOOD
      
      board(location_x: SHELL_MARGIN, location_y: SHELL_MARGIN)

      available_pieces_area(game: @game, location_x: SHELL_MARGIN + BOARD_DIAMETER + AREA_MARGIN, location_y: SHELL_MARGIN)
      selected_piece_area(game: @game, location_x: SHELL_MARGIN + BOARD_DIAMETER + AREA_MARGIN, location_y: SHELL_MARGIN + AVAILABLE_PIECES_AREA_HEIGHT + AREA_MARGIN)
    }
  }
end

Quarto.launch
