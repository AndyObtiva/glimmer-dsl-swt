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
        evaluate_horizontal_win
        evaluate_vertical_win
        evaluate_sw_ne_diagonal_win
        evaluate_se_nw_diagonal_win
        self.game_over ||= true if @slot_rows.flatten.map(&:value).all? {|v| v > 0}
      end
      
      def evaluate_horizontal_win
        connections = nil
        last_slot_value = nil
        height.times do |row_index|
          connections = nil
          last_slot_value = nil
          width.times do |column_index|
            slot = @slot_rows[row_index][column_index]
            if slot.value.to_i > 0 && slot.value == last_slot_value
              connections += 1
            else
              last_slot_value = slot.value
              connections = 1
            end
            break if connections == 4
          end
          break if connections == 4
        end
        self.game_over = last_slot_value if connections == 4
      end
      
      def evaluate_vertical_win
        connections = nil
        last_slot_value = nil
        width.times do |column_index|
          connections = nil
          last_slot_value = nil
          height.times do |row_index|
            slot = @slot_rows[row_index][column_index]
            if slot.value.to_i > 0 && slot.value == last_slot_value
              connections += 1
            else
              last_slot_value = slot.value
              connections = 1
            end
            break if connections == 4
          end
          break if connections == 4
        end
        self.game_over = last_slot_value if connections == 4
      end
      
      def evaluate_sw_ne_diagonal_win
        sw_ne_coordinates = [
          [[3, 0], [2, 1], [1, 2], [0, 3]],
          [[4, 0], [3, 1], [2, 2], [1, 3], [0, 4]],
          [[5, 0], [4, 1], [3, 2], [2, 3], [1, 4], [0, 5]],
          [[5, 1], [4, 2], [3, 3], [2, 4], [1, 5], [0, 6]],
          [[5, 2], [4, 3], [3, 4], [2, 5], [1, 6]],
          [[5, 3], [4, 4], [3, 5], [2, 6]],
        ]
        evaluate_diagonal_win(sw_ne_coordinates)
      end
      
      def evaluate_se_nw_diagonal_win
        sw_ne_coordinates = [
          [[0, 3], [1, 4], [2, 5], [3, 6]],
          [[0, 2], [1, 3], [2, 4], [3, 5], [4, 6]],
          [[0, 1], [1, 2], [2, 3], [3, 4], [4, 5], [5, 6]],
          [[0, 0], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5]],
          [[1, 0], [2, 1], [3, 2], [4, 3], [5, 4]],
          [[2, 0], [3, 1], [4, 2], [5, 3]],
        ]
        evaluate_diagonal_win(sw_ne_coordinates)
      end
      
      def evaluate_diagonal_win(diagonal_coordinates)
        connections = nil
        last_slot_value = nil
        diagonal_coordinates.each do |group|
          connections = nil
          last_slot_value = nil
          group.each do |row_index, column_index|
            slot = @slot_rows[row_index][column_index]
            if slot.value.to_i > 0 && slot.value == last_slot_value
              connections += 1
            else
              last_slot_value = slot.value
              connections = 1
            end
            break if connections == 4
          end
          break if connections == 4
        end
        self.game_over = last_slot_value if connections == 4
      end
    
    end
    
  end
  
end
