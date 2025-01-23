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

class GameOfLife
  module Model
    class Cell
      attr_reader :grid, :row_index, :column_index
      attr_accessor :alive
      alias alive? alive
    
      def initialize(grid, row_index, column_index, alive=false)
        @grid = grid
        @row_index = row_index
        @column_index = column_index
        @alive = alive
      end
      
      def live!
        self.alive = true
      end
      
      def die!
        self.alive = false
      end
      
      def toggle_aliveness!
        return if grid.playing?
        dead ? live! : die!
      end
      
      def dead?
        !alive?
      end
      alias dead dead?
      
      # step into the next generation
      def step!
        self.alive = (alive? && alive_neighbor_count.between?(2, 3)) || (dead? && alive_neighbor_count == 3)
      end
      
      def alive_neighbor_count
        [row_index - 1, 0].max.upto([row_index + 1, grid.row_count - 1].min).map do |current_row_index|
          [column_index - 1, 0].max.upto([column_index + 1, grid.column_count - 1].min).map do |current_column_index|
            if current_row_index == row_index && current_column_index == column_index
              0
            else
              grid.previous_cell_rows[current_row_index][current_column_index].alive? ? 1 : 0
            end
          end
        end.flatten.reduce(:+)
      end
    end
  end
end
