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

require_relative 'block'
require_relative 'tetromino'

class Tetris
  module Model
    class Game
      class << self
        def consider_adding_tetromino
          if tetrominoes.empty? || Game.current_tetromino.stopped?
            tetrominoes << Tetromino.new
          end
        end
        
        def current_tetromino
          tetrominoes.last
        end
      
        def tetrominoes
          @tetrominoes ||= reset_tetrominoes
        end
        
        # Returns blocks in the playfield
        def playfield
          @playfield ||= PLAYFIELD_HEIGHT.times.map {
            PLAYFIELD_WIDTH.times.map {
              Block.new
            }
          }
        end
        
        def consider_eliminating_lines
          cleared_line = false
          playfield.each_with_index do |row, playfield_row|
            if row.all? {|block| !block.clear?}
              cleared_line = true
              shift_blocks_down_above_row(playfield_row)
            end
          end
          beep if cleared_line
        end
        
        def beep
          @beeper&.call
        end
        
        def configure_beeper(&beeper)
          @beeper = beeper
        end
        
        def shift_blocks_down_above_row(row)
          row.downto(0) do |playfield_row|
             playfield[playfield_row].each_with_index do |block, playfield_column|
               previous_row = playfield[playfield_row - 1]
               previous_block = previous_row[playfield_column]
               block.color = previous_block.color
             end
          end
          playfield[0].each(&:clear)
        end
        
        def restart
          reset_playfield
          reset_tetrominoes
        end
        alias start restart
        
        def reset_tetrominoes
          @tetrominoes = [Tetromino.new]
        end
        
        def reset_playfield
          playfield.each do |row|
            row.each do |block|
              block.clear
            end
          end
        end
        
        def playfield_remaining_heights(tetromino = nil)
          PLAYFIELD_WIDTH.times.map do |playfield_column|
            (playfield.each_with_index.detect do |row, playfield_row|
              !row[playfield_column].clear? &&
              (
                tetromino.nil? ||
                tetromino.bottom_block_for_column(playfield_column).nil? ||
                (playfield_row > tetromino.row + tetromino.bottom_block_for_column(playfield_column)[:row])
              )
            end || [nil, PLAYFIELD_HEIGHT])[1]
          end.to_a
        end
      end
    end
  end
end
    
