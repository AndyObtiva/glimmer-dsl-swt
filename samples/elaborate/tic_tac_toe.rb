# Copyright (c) 2007-2025 Andy Maleh
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

require_relative "tic_tac_toe/board"

class TicTacToe
  include Glimmer::UI::CustomShell

  before_body do
    @tic_tac_toe_board = Board.new
  end
  
  after_body do
    observe(@tic_tac_toe_board, :game_status) do |game_status|
      display_win_message if game_status == Board::WIN
      display_draw_message if game_status == Board::DRAW
    end
  end

  body {
    shell {
      text "Tic-Tac-Toe"
      minimum_size 176, 200

      composite {
        grid_layout 3, true

        (1..3).each { |row|
          (1..3).each { |column|
            button {
              layout_data :fill, :fill, true, true
              text        <= [@tic_tac_toe_board[row, column], :sign]
              enabled     <= [@tic_tac_toe_board[row, column], :empty]
              font        style: :bold, height: (OS.windows? ? 18 : 20)

              on_widget_selected do
                @tic_tac_toe_board.mark(row, column)
              end
            }
          }
        }
      }
    }
  }

  def display_win_message
    display_game_over_message("Player #{@tic_tac_toe_board.winning_sign} has won!")
  end

  def display_draw_message
    display_game_over_message("Draw!")
  end

  def display_game_over_message(message_text)
    message_box {
      text 'Game Over'
      message message_text
    }.open
    @tic_tac_toe_board.reset!
  end
end

TicTacToe.launch
