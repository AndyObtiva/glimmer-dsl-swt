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

require_relative 'cell'

class Battleship
  module Model
    class Grid
      HEIGHT = 10
      WIDTH = 10
      ROW_ALPHABETS = %w[A B C D E F G H I J]
      
      attr_reader :game, :player, :cell_rows
            
      def initialize(game, player)
        @game = game
        @player = player
        build
      end
      
      def reset!
        @cell_rows.flatten.each(&:reset!)
      end

      private
            
      def build
        @cell_rows = HEIGHT.times.map do |row_index|
          WIDTH.times.map do |column_index|
            Cell.new(self, row_index, column_index)
          end
        end
      end
    end
  end
end
