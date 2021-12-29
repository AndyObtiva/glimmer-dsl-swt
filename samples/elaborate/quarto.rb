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
    
    observe(@game, :current_move) do
      # TODO consider async_exec to have perform_current_move show message box panel successfully after game over
      perform_current_move
    end
    
    observe(@game, :game_over) do |game_over_winner|
      if game_over_winner
        body_root.content {
          @open_message_box_panel&.close
          @open_message_box_panel = message_box_panel(
            message: "Game Over! Player #{@game.game_over} wins!",
            background_color: COLOR_LIGHT_WOOD,
            text_font: {height: 16}
          ) {
            on_closed do
              @available_pieces_area.reset_pieces
              @board.reset_cells
              # TODO have board and available pieces area auto-reset themselves upon game restart instead of reseting from here manually
              @game.restart
            end
          }
        }
      end
    end
  end
  
  after_body do
    perform_current_move
  end
  
  body {
    shell {
      text 'Glimmer Quarto'
      minimum_size BOARD_DIAMETER + AREA_MARGIN + PIECES_AREA_WIDTH + SHELL_MARGIN*2, BOARD_DIAMETER + 24 + SHELL_MARGIN*2
      maximum_size BOARD_DIAMETER + AREA_MARGIN + PIECES_AREA_WIDTH + SHELL_MARGIN*2, BOARD_DIAMETER + 24 + SHELL_MARGIN*2
      background COLOR_WOOD
      
      @board = board(game: @game, location_x: SHELL_MARGIN, location_y: SHELL_MARGIN)
  
      @available_pieces_area = available_pieces_area(game: @game, location_x: SHELL_MARGIN + BOARD_DIAMETER + AREA_MARGIN, location_y: SHELL_MARGIN)
      @selected_piece_area = selected_piece_area(game: @game, location_x: SHELL_MARGIN + BOARD_DIAMETER + AREA_MARGIN, location_y: SHELL_MARGIN + AVAILABLE_PIECES_AREA_HEIGHT + AREA_MARGIN)
    }
  }
  
  def perform_current_move
    verbiage = nil
    case @game.current_move
    when :select_piece
      @available_pieces_area.pieces.each {|piece| piece.drag_source = true}
      verbiage = "Player #{@game.current_player_number} must drag a piece to the Selected Piece\narea for the other player to place on the board!"
    when :place_piece
      @available_pieces_area.pieces.each {|piece| piece.drag_source = false}
      @selected_piece_area.selected_piece.drag_source = true
      verbiage = "Player #{@game.current_player_number} must drag the selected piece to the board\nin order to place it!"
    end
    body_root.text = "Glimmer Quarto | Player #{@game.current_player_number} #{@game.current_move.to_s.split('_').map(&:capitalize).join(' ')}"
    body_root.content {
      @open_message_box_panel&.close
      @open_message_box_panel = message_box_panel(
        message: verbiage,
        background_color: COLOR_LIGHT_WOOD,
        text_font: {height: 16}
      )
    }
  end
end

Quarto.launch
