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
      SCORE_MULTIPLIER = {1 => 40, 2 => 100, 3 => 300, 4 => 1200}
      
      class << self
        attr_accessor :game_over, :preview_tetromino, :lines, :score, :level
        alias game_over? game_over
        
        def consider_adding_tetromino
          if tetrominoes.empty? || Game.current_tetromino.stopped?
            preview_tetromino.launch!
            preview_next_tetromino!
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
          @playfield ||= @original_playfield = PLAYFIELD_HEIGHT.times.map {
            PLAYFIELD_WIDTH.times.map {
              Block.new
            }
          }
        end
        
        def hypothetical(&block)
          @playfield = hypothetical_playfield
          block.call
          @playfield = @original_playfield
        end
        
        def hypothetical?
          @playfield != @original_playfield
        end
        
        def hypothetical_playfield
          PLAYFIELD_HEIGHT.times.map { |row|
            PLAYFIELD_WIDTH.times.map { |column|
              playfield[row][column].clone
            }
          }
        end
        
        def preview_playfield
          @preview_playfield ||= PREVIEW_PLAYFIELD_HEIGHT.times.map {|row|
            PREVIEW_PLAYFIELD_WIDTH.times.map {|column|
              Block.new
            }
          }
        end
        
        def preview_next_tetromino!
          self.preview_tetromino = Tetromino.new
        end
        
        def calculate_score!(eliminated_lines)
          new_score = SCORE_MULTIPLIER[eliminated_lines] * (level + 1)
          self.score += new_score
        end
        
        def level_up!
          self.level += 1 if lines >= self.level*10
        end
        
        def delay
          [1.1 - (level.to_i * 0.1), 0.001].max
        end
        
        def consider_eliminating_lines
          eliminated_lines = 0
          playfield.each_with_index do |row, playfield_row|
            if row.all? {|block| !block.clear?}
              eliminated_lines += 1
              shift_blocks_down_above_row(playfield_row)
            end
          end
          if eliminated_lines > 0
            beep
            self.lines += eliminated_lines
            level_up!
            calculate_score!(eliminated_lines)
          end
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
               block.color = previous_block.color unless block.color == previous_block.color
             end
          end
          playfield[0].each(&:clear)
        end
        
        def start
          self.level = 1
          self.score = 0
          self.lines = @previoius_lines = 0
          reset_playfield
          reset_preview_playfield
          reset_tetrominoes
          preview_next_tetromino!
          consider_adding_tetromino
          self.game_over = false
        end
        alias restart start
        
        def reset_tetrominoes
          @tetrominoes = []
        end
        
        def reset_playfield
          playfield.each do |row|
            row.each do |block|
              block.clear
            end
          end
        end
        
        def reset_preview_playfield
          preview_playfield.each do |row|
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
                (bottom_most_block = tetromino.bottom_most_block_for_column(playfield_column)).nil? ||
                (playfield_row > tetromino.row + bottom_most_block[:row])
              )
            end || [nil, PLAYFIELD_HEIGHT])[1]
          end.to_a
        end
      end
    end
  end
end
    
