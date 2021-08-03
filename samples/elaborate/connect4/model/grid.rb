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

require_relative 'slot'

class Connect4
  module Model
    class Grid
      attr_reader :width, :height, :slot_rows
      attr_accessor :current_player, :game_over
    
      def initialize(width, height)
        @width = width
        @height = height
        build_slots
        start!
      end
      
      def start!
        self.game_over = false
        self.current_player = 1
        reset_slots
      end
      alias restart! start!
      
      def insert!(column_index)
        found_row_index = bottom_most_free_row_index(column_index)
        raise "Illegal move at #{column_index}" if found_row_index == -1
        @slot_rows[found_row_index][column_index].value = @current_player
        self.current_player = @current_player%2 + 1
        evaluate_game_over
      end
      
      # returns bottom most free row index
      # returns -1 if none
      def bottom_most_free_row_index(column_index)
        found_row_index = @slot_rows.size - 1
        found_row_index -= 1 until found_row_index == -1 || @slot_rows[found_row_index][column_index].value == 0
        found_row_index
      end
      
      private
      
      def build_slots
        @slot_rows = height.times.map do |row_index|
          width.times.map do |column_index|
            Slot.new(self)
          end
        end
      end
      
      def reset_slots
        @slot_rows.flatten.each {|s| s.value = 0}
      end
      
      def evaluate_game_over
        # TODO evaluate horizontal/vertical/diagonal wins
        self.game_over = true if @slot_rows.flatten.map(&:value).all? {|v| v > 0}
      end
    end
  end
end
