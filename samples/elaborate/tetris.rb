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

require 'matrix'

class Tetris
  include Glimmer::UI::CustomShell
  
  class Model
    class Tetromino
      ORIENTATIONS = [:north, :east, :south, :west]
      
      LETTER_COLORS = {
        I: :cyan,
        J: :blue,
        L: :dark_yellow,
        O: :yellow,
        S: :green,
        T: :magenta,
        Z: :red,
      }
      
      attr_reader :letter
      attr_accessor :orientation, :blocks, :row, :column
      
      def initialize
        @letter = LETTER_COLORS.keys.sample
        @orientation = :north
        @blocks = default_blocks
        new_row = 0
        new_column = (10 - width)/2 - 1
        update_playfield(new_row, new_column)
      end
      
      def update_playfield(new_row = nil, new_column = nil)
        remove_from_playfield
        if !new_row.nil? && !new_column.nil?
          @row = new_row
          @column = new_column
          add_to_playfield
        end
      end
      
      def add_to_playfield
        update_playfield_block do |playfield_row, playfield_column, row_index, column_index|
          Model.playfield[playfield_row][playfield_column].color = blocks[row_index][column_index].color
        end
      end
      
      def remove_from_playfield
        return if @row.nil? || @column.nil?
        update_playfield_block do |playfield_row, playfield_column|
          Model.playfield[playfield_row][playfield_column].clear
        end
      end
      
      def stopped?(blocks: nil)
        blocks ||= @blocks
        blocks.each do |row|
          puts row.inspect
        end
        pd playfield_remaining_heights = Model.playfield_remaining_heights(self)
        blocks.last.each_with_index.any? do |column, column_index|
          @row == playfield_remaining_heights[column_index] - height
        end
      end
      
      def width
        @blocks[0].size
      end
      
      def height
        @blocks.size
      end
      
      def down
        unless stopped?
          new_row = @row + 1
          update_playfield(new_row, @column)
        end
      end
      
      def left
        unless @column == 0
          new_column = @column - 1
          update_playfield(@row, new_column)
        end
      end
      
      def right
        unless @column == 10 - width
          new_column = @column + 1
          update_playfield(@row, new_column)
        end
      end
      
      # Rotate in specified direcation, which can be :right (clockwise) or :left (counterclockwise)
      def rotate(direction)
        array_rotation_value = direction == :right ? -1 : 1
        self.orientation = ORIENTATIONS[ORIENTATIONS.rotate(array_rotation_value).index(@orientation)]
        new_blocks = Matrix[*@blocks].transpose.to_a
        if direction == :right
          new_blocks = new_blocks.map(&:reverse)
        else
          new_blocks = new_blocks.reverse
        end
        new_blocks = Matrix[*new_blocks].to_a
        # TODO update row and/or column based on rotation, recentering the tetromino
        unless stopped?(blocks: new_blocks)
          remove_from_playfield
          self.blocks = new_blocks
          update_playfield(@row, @column)
        end
      end
      
      def default_blocks
        case @letter
        when :I
          [
            [block, block, block, block]
          ]
        when :J
          [
            [block, block, block],
            [empty, empty, block],
          ]
        when :L
          [
            [block, block, block],
            [block, empty, empty],
          ]
        when :O
          [
            [block, block],
            [block, block],
          ]
        when :S
          [
            [empty, block, block],
            [block, block, empty],
          ]
        when :T
          [
            [block, block, block],
            [empty, block, empty],
          ]
        when :Z
          [
            [block, block, empty],
            [empty, block, block],
          ]
        end
      end
      
      def color
        LETTER_COLORS[@letter]
      end
      
      private
      
      def block
        Block.new(color)
      end
      
      def empty
        Block.new
      end
      
      def update_playfield_block(&updater)
        @row.upto(@row + height - 1) do |playfield_row|
          @column.upto(@column + width - 1) do |playfield_column|
            row_index = playfield_row - @row
            column_index = playfield_column - @column
            updater.call(playfield_row, playfield_column, row_index, column_index)
          end
        end
      end
    end
    
    class Block
      COLOR_CLEAR = :white
    
      attr_accessor :color
      
      # Initializes with color. Default color (gray) signifies an empty block
      def initialize(color = COLOR_CLEAR)
        @color = color
      end
      
      def clear
        self.color = COLOR_CLEAR
      end
      
      def clear?
        self.color == COLOR_CLEAR
      end
    end
    
    class << self
      # TODO convert to instance methods
      def consider_adding_tetromino
        if tetrominoes.empty? || Model.current_tetromino.stopped?
          tetrominoes << Tetromino.new
        end
      end
      
      def current_tetromino
        tetrominoes.last
      end
    
      def tetrominoes
        @tetrominoes ||= []
      end
      
      # Returns blocks in the playfield
      def playfield
        @playfield ||= 20.times.map {
          10.times.map {
            Block.new
          }
        }
      end
      
      def reset_playfield
        @tetrominoes = []
        @playfield.each do |row|
          row.each do |block|
            block.clear
          end
        end
      end
      
      def playfield_remaining_heights(tetromino = nil)
        # TODO optimize by limiting columns when teromino is passed
        10.times.map do |column_index|
          (playfield.each_with_index.detect do |row, row_index|
            found = !row[column_index].clear?
            if found && !tetromino.nil?
              pd(found, header: true) if tetromino.letter == :O
              pd row_index, tetromino.row, tetromino.row + tetromino.height - 1
              pd column_index, tetromino.column, tetromino.column + tetromino.width - 1
              pd !column_index.between?(tetromino.column, tetromino.column + tetromino.width - 1)
              pd row_index > tetromino.row + tetromino.height - 1
              found = ((found && !column_index.between?(tetromino.column, tetromino.column + tetromino.width - 1)) ||
                        (found && row_index > tetromino.row + tetromino.height - 1))
              pd found if tetromino.letter == :O
            end
           found
          end || [nil, 20])[1]
        end.to_a
      end
    end
  end
    
#   class Block
#     include Glimmer::UI::CustomWidget
#
#     options :block_color, :block_size
#
#     body {
#       canvas {
#         rectangle(0, 0, block_size, block_size, fill: true) {
#           background block_color
#         }
#         rectangle(0, 0, block_size, block_size)
#       }
#     }
#   end
  
  before_body {
    display {
      on_swt_keyup { |key_event|
        case key_event.keyCode
        when swt(:arrow_down)
          Tetris::Model.current_tetromino.down
        when swt(:arrow_left)
          Tetris::Model.current_tetromino.left
        when swt(:arrow_right)
          Tetris::Model.current_tetromino.right
        when swt(:shift)
          if key_event.keyLocation == swt(:right) # right shift key
            Tetris::Model.current_tetromino.rotate(:right)
          elsif key_event.keyLocation == swt(:left) # left shift key
            Tetris::Model.current_tetromino.rotate(:left)
          end
        when 'd'.bytes.first
          Tetris::Model.current_tetromino.rotate(:right)
        when 'a'.bytes.first
          Tetris::Model.current_tetromino.rotate(:left)
        end
      }
    }
  }
  
  after_body {
    display # ensure display is pre-initialized on main thread # TODO look into why async_exec bombs otherwise or inspite of
    Thread.new {
      loop {
        async_exec {
          Model.consider_adding_tetromino unless @game_over
        }
        sleep(1)
        async_exec {
          unless @game_over
            Model.current_tetromino.down
            if Model.current_tetromino.stopped? && Model.current_tetromino.row <= 0
              @game_over = true
              message_box {
                text 'Tetris'
                message 'Game Over!'
              }.open
              Model.reset_playfield
              @game_over = false
            end
          end
        }
      }
    }
  }
  
  BLOCK_SIZE = 25
  
  body {
    shell { # TODO set to (:no_resize)
      text 'Tetris'
      background :gray
      
      composite {
        grid_layout(10, true) {
          margin_width BLOCK_SIZE
          margin_height BLOCK_SIZE
          horizontal_spacing 0
          vertical_spacing 0
        }
        
        20.times { |row|
          10.times { |column|
            composite {
              layout nil
              layout_data {
                width_hint BLOCK_SIZE
                height_hint BLOCK_SIZE
              }
              background bind(Model.playfield[row][column], :color)
            }
          }
        }
      }
    }
  }
end

Tetris.launch
