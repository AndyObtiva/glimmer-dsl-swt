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

require_relative 'cell'

class Battleship
  module Model
    class Ship
      ORIENTATIONS = [:horizontal, :vertical]
      
      attr_reader :ship_collection, :name, :length
      attr_accessor :orientation, :cell
            
      def initialize(ship_collection, name, length)
        @ship_collection = ship_collection
        @name = name
        @length = length
        @orientation = :horizontal
      end
        
      def cells
        if cell
          length.times.map do |index|
            if orientation == :horizontal
              cell.grid.cell_rows[cell.row_index][cell.column_index + index]
            else
              cell.grid.cell_rows[cell.row_index + index][cell.column_index]
            end
          end
        end
      end
      
      def reset!
        ships.each(&:reset!)
      end
    end
  end
end
