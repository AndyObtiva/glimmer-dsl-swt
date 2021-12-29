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
require_relative 'piece/cube'
require_relative 'piece/cylinder'

class Quarto
  module Model
    class Game
      MOVES = [:select_piece, :place_piece]
      PLAYER_NUMBERS = [1, 2]
      ROW_COUNT = 4
      COLUMN_COUNT = 4
    
      attr_accessor :board, :available_pieces, :selected_piece, :current_move, :current_player_number, :game_over
      
      def initialize
        start
      end
      
      def start
        self.game_over = false
        self.board = ROW_COUNT.times.map {COLUMN_COUNT.times.map {nil}}
        self.available_pieces = Piece.all_pieces.dup
        self.current_player_number = 1
        self.current_move = MOVES.first
      end
      alias restart start
      
      def select_piece(piece)
        self.selected_piece = piece
        next_player
        next_move
      end
      
      def place_piece(piece, row:, column:)
        if @board[row][column].nil?
          @board[row][column] = piece
          if win?
            self.game_over = current_player_number
          else
            next_move
          end
        end
      end
      
      def next_move
        last_move = current_move
        last_move_index = MOVES.index(last_move)
        self.current_move = MOVES[(last_move_index + 1)%MOVES.size]
      end
      
      def next_player
        last_player_number = current_player_number
        last_player_number_index = PLAYER_NUMBERS.index(current_player_number)
        self.current_player_number = PLAYER_NUMBERS[(last_player_number_index + 1)%PLAYER_NUMBERS.size]
      end
      
      def win?
        row_win? || column_win? || diagonal_win?
      end
      
      def row_win?
        ROW_COUNT.times.any? { |row| equivalent_pieces?(@board[row]) }
      end
      
      def column_win?
        COLUMN_COUNT.times.any? do |column|
          equivalent_pieces?(ROW_COUNT.times.map {|row| @board[row][column]})
        end
      end
      
      def diagonal_win?
        diagonal1_win? || diagonal2_win?
      end
      
      def diagonal1_win?
        equivalent_pieces?(ROW_COUNT.times.map { |n| @board[n][n] })
      end
      
      def diagonal2_win?
        equivalent_pieces?(ROW_COUNT.times.map { |n| @board[ROW_COUNT - 1 - n][n] })
      end
      
      def equivalent_pieces?(the_pieces)
        return false if the_pieces.any?(&:nil?)
        the_pieces.map(&:class).uniq.size == 1 ||
          the_pieces.map(&:pitted).uniq.size == 1 ||
          the_pieces.map(&:height).uniq.size == 1 ||
          the_pieces.map(&:color).uniq.size == 1
      end
    end
  end
end
