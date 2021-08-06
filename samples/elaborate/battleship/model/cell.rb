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

class Battleship
  module Model
    class Cell
      attr_reader :grid, :row_index, :column_index
      attr_accessor :hit, :ship, :ship_index
      alias hit? hit
            
      def initialize(grid, row_index, column_index)
        @grid = grid
        @row_index = row_index
        @column_index = column_index
      end
      
      def reset!
        # TODO consider an occupied attribute too
        self.hit = nil
        self.ship = nil
        self.ship_index = nil
      end
      
      # Places ship horizontally so that its top left cell is self,
      # automatically figuring out the rest of the cells
      def place_ship!(ship)
        begin
          old_ship_top_left_cell = ship.top_left_cell
          old_ship_orientation = ship.orientation
          ship.top_left_cell = self
          if old_ship_top_left_cell
            ship.cells(old_ship_orientation).each(&:reset!)
            ship.length.times do |index|
              if ship.orientation == :horizontal
                old_cell = grid.cell_rows[old_ship_top_left_cell.row_index][old_ship_top_left_cell.column_index + index]
              else
                old_cell = grid.cell_rows[old_ship_top_left_cell.row_index + index][old_ship_top_left_cell.column_index]
              end
              old_cell.reset!
            end
          end
          ship.length.times do |index|
            if ship.orientation == :horizontal
              cell = grid.cell_rows[row_index][column_index + index]
            else
              cell = grid.cell_rows[row_index + index][column_index]
            end
            cell.ship = ship
            cell.ship_index = index
          end
        rescue => e
          Glimmer::Config.logger.debug(e.full_message)
        end
      end
      
      def to_s
        "#{(Grid::ROW_ALPHABETS[row_index])}#{(column_index + 1)}"
      end
    end
  end
end
