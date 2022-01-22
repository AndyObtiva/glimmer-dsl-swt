# Copyright (c) 2007-2022 Andy Maleh
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
    class Ship
      ORIENTATIONS = [:horizontal, :vertical]
      
      attr_reader :ship_collection, :name, :length
      attr_accessor :orientation, :top_left_cell, :sunk
      alias sunk? sunk
            
      def initialize(ship_collection, name, length)
        @ship_collection = ship_collection
        @name = name
        @length = length
        @orientation = :horizontal
      end
      
      def to_s
        "#{name.titlecase} (#{length} cells)"
      end
      
      def top_left_cell=(a_cell)
        if a_cell
          raise "Top left cell #{a_cell} already occupied by ship #{a_cell.ship.name}" if a_cell.ship && a_cell.ship != self
          raise "Top left cell #{a_cell} cannot fit ship #{name}" if a_cell.column_index + length > Grid::WIDTH
          grid = ship_collection.game.grids[ship_collection.player]
          1.upto(length - 1).each do |index|
            if orientation == :horizontal
              other_cell = grid.cell_rows[a_cell.row_index][a_cell.column_index + index]
            else
              other_cell = grid.cell_rows[a_cell.row_index + index][a_cell.column_index]
            end
            raise "Cell #{other_cell} already occupied by ship #{other_cell.ship.name}" if other_cell.ship && other_cell.ship != self
          end
        end
        @top_left_cell = a_cell
      end
      
      def orientation=(value)
        if top_left_cell
          if value == :horizontal
            if top_left_cell.column_index + length > Grid::WIDTH
              raise "Top left cell #{top_left_cell} cannot fit ship #{name}"
            end
          else
            if top_left_cell.row_index + length > Grid::HEIGHT
              raise "Top left cell #{top_left_cell} cannot fit ship #{name}"
            end
          end
          if cells(value)[1..-1].map(&:ship).reject {|s| s == self}.any?
            raise 'Orientation #{value} cells occupied by another ship'
          end
          if value != @orientation
            cells.each(&:reset!)
            @orientation = value
            cells.each_with_index do |cell, index|
              cell.ship = self
              cell.ship_index = index
            end
          end
        end
      end
        
      def cells(for_orientation = nil)
        for_orientation ||= orientation
        if top_left_cell
          length.times.map do |index|
            if for_orientation == :horizontal
              top_left_cell.grid.cell_rows[top_left_cell.row_index][top_left_cell.column_index + index]
            else
              top_left_cell.grid.cell_rows[top_left_cell.row_index + index][top_left_cell.column_index]
            end
          end
        end
      end
      
      def all_cells_hit?
        cells&.map(&:hit)&.all? {|h| h == true}
      end
      
      def reset!
        self.sunk = nil
        self.top_left_cell = nil
        self.orientation = :horizontal
      end
      
      def toggle_orientation!
        self.orientation = ORIENTATIONS[(ORIENTATIONS.index(orientation) + 1) % ORIENTATIONS.length]
      end
    end
  end
end
