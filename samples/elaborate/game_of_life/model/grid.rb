# Copyright (c) 2007-2023 Andy Maleh
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

class GameOfLife
  module Model
    class Grid
      include Glimmer # included only to utilize sync_exec/async_exec
      DEFAULT_ROW_COUNT = 100
      DEFAULT_COLUMN_COUNT = 100
      
      attr_reader :row_count, :column_count
      attr_accessor :cell_rows, :previous_cell_rows, :playing, :speed
      alias playing? playing
    
      def initialize(row_count=DEFAULT_ROW_COUNT, column_count=DEFAULT_COLUMN_COUNT)
        @row_count = row_count
        @column_count = column_count
        @speed = 10.0
        build_cells
      end
      
      def clear!
        cell_rows.each do |row|
          row.each do |cell|
            cell.die!
          end
        end
      end
      
      # steps into the next generation of cells given their current neighbors
      def step!
        self.previous_cell_rows = cell_rows.map do |row|
          row.map do |cell|
            cell.clone
          end
        end
        cell_rows.each do |row|
          row.each do |cell|
            cell.step!
          end
        end
      end
      
      def toggle_playback!
        if playing?
          stop!
        else
          play!
        end
      end
      
      def play!
        self.playing = true
        Thread.new do
          while @playing
            sync_exec { step! }
            sleep(1.0/@speed)
          end
        end
      end
      
      def stop!
        self.playing = false
      end
      
      private
      
      def build_cells
        @cell_rows = @row_count.times.map do |row_index|
          @column_count.times.map do |column_index|
            Cell.new(self, row_index, column_index)
          end
        end
      end
    end
  end
end
