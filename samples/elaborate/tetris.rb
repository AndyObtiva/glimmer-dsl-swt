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

# Tetris App View Custom Shell (represents `tetris` keyword)
class Tetris
  include Glimmer::UI::CustomShell
  
  BLOCK_SIZE = 25
  PLAYFIELD_WIDTH = 10
  PLAYFIELD_HEIGHT = 20
  
  # Game Presenter Model
  class Game
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
        new_column = (PLAYFIELD_WIDTH - width)/2 - 1
        update_playfield(new_row, new_column)
      end
      
      def update_playfield(new_row = nil, new_column = nil)
        # TODO consider using an observer instead
        remove_from_playfield
        if !new_row.nil? && !new_column.nil?
          @row = new_row
          @column = new_column
          add_to_playfield
        end
      end
      
      def add_to_playfield
        update_playfield_block do |playfield_row, playfield_column, row_index, column_index|
          Game.playfield[playfield_row][playfield_column].color = blocks[row_index][column_index].color if Game.playfield[playfield_row][playfield_column].clear? && !blocks[row_index][column_index].clear?
        end
      end
      
      def remove_from_playfield
        return if @row.nil? || @column.nil?
        update_playfield_block do |playfield_row, playfield_column, row_index, column_index|
          Game.playfield[playfield_row][playfield_column].clear unless blocks[row_index][column_index].clear?
        end
      end
      
      def stopped?(blocks: nil)
        # TODO add time delay for when stopped? status sticks so user can move block left and right still for a short period of time
        blocks ||= @blocks
        playfield_remaining_heights = Game.playfield_remaining_heights(self)
        bottom_blocks(blocks).any? do |bottom_block|
          playfield_column = @column + bottom_block[:column_index]
          !bottom_block[:block].clear? &&
            (@row + bottom_block[:row]) >= playfield_remaining_heights[playfield_column] - 1
        end
      end
      
      # Returns blocks at the bottom of a tetromino, which could be from multiple rows depending on shape (e.g. T)
      def bottom_blocks(blocks = nil)
        blocks ||= @blocks
        width.times.map do |column_index|
          row_blocks_with_row_index = @blocks.each_with_index.to_a.reverse.detect do |row_blocks, row_index|
            !row_blocks[column_index].clear?
          end
          bottom_block = row_blocks_with_row_index[0][column_index]
          bottom_block_row = row_blocks_with_row_index[1]
          {
            block: bottom_block,
            row: bottom_block_row,
            column_index: column_index
          }
        end
      end
      
      def bottom_block_for_column(column)
        bottom_blocks.detect {|bottom_block| (@column + bottom_block[:column_index]) == column}
      end
      
      def right_blocked?
        @column == PLAYFIELD_WIDTH - width
      end
      
      def left_blocked?
        @column == 0
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
          Game.consider_eliminating_lines # TODO consider using an observer instead for when a move is made
        end
      end
      
      def left
        unless left_blocked?
          new_column = @column - 1
          update_playfield(@row, new_column)
          Game.consider_eliminating_lines # TODO consider using an observer instead for when a move is made
        end
      end
      
      def right
        unless right_blocked?
          new_column = @column + 1
          update_playfield(@row, new_column)
          Game.consider_eliminating_lines # TODO consider using an observer instead for when a move is made
        end
      end
      
      # Rotate in specified direcation, which can be :right (clockwise) or :left (counterclockwise)
      def rotate(direction)
        return if stopped?
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
        unless stopped?(blocks: new_blocks) || right_blocked? || left_blocked?
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
    
  class Block
    include Glimmer::UI::CustomWidget

    options :block_size, :row, :column

    body {
      composite {
        layout nil
        layout_data {
          width_hint BLOCK_SIZE
          height_hint BLOCK_SIZE
        }
        background bind(Game.playfield[row][column], :color)
        # TODO improve shapes to have a bevel look
        rectangle(0, 0, BLOCK_SIZE, BLOCK_SIZE)
        rectangle(3, 3, BLOCK_SIZE - 6, BLOCK_SIZE - 6) {
          foreground :gray
        }
      }
    }
  end
  
  class Block
    include Glimmer::UI::CustomWidget

    options :block_size, :row, :column

    body {
      composite {
        layout nil
        layout_data {
          width_hint block_size
          height_hint block_size
        }
        background bind(Game.playfield[row][column], :color)
        # TODO improve shapes to have a bevel look
        rectangle(0, 0, block_size, block_size)
        rectangle(3, 3, block_size - 6, block_size - 6) {
          foreground :gray
        }
      }
    }
  end
  
  before_body {
    Game.configure_beeper do
      display.beep
    end
    
    Game.start
    
    display {
      on_swt_keydown { |key_event|
        unless Tetris::Game.current_tetromino.stopped?
          # TODO handle issue with down button holding off movevement of shapes once they touch down
          case key_event.keyCode
          when swt(:arrow_down)
            Tetris::Game.current_tetromino.down
          when swt(:arrow_left)
            Tetris::Game.current_tetromino.left
          when swt(:arrow_right)
            Tetris::Game.current_tetromino.right
          when swt(:shift)
            if key_event.keyLocation == swt(:right) # right shift key
              Tetris::Game.current_tetromino.rotate(:right)
            elsif key_event.keyLocation == swt(:left) # left shift key
              Tetris::Game.current_tetromino.rotate(:left)
            end
          when 'd'.bytes.first, swt(:arrow_up) # TODO consider changing up button to immediate drop
            Tetris::Game.current_tetromino.rotate(:right)
          when 'a'.bytes.first
            Tetris::Game.current_tetromino.rotate(:left)
          end
        end
      }
    }
  }
  
  after_body {
    Thread.new {
      loop {
        sleep(1)
        # TODO add processing delay for when stopped? status sticks so user can move block left and right still for a short period of time
        async_exec {
          unless @game_over
            Game.current_tetromino.down
            if Game.current_tetromino.stopped? && Game.current_tetromino.row == 0
              # TODO extract to a declare_game_over method
              @game_over = true
              display.beep
              message_box(:icon_error) {
                text 'Tetris'
                message 'Game Over!'
              }.open
              Game.restart
              @game_over = false
            end
            Game.consider_adding_tetromino
          end
        }
      }
    }
  }
  
  body {
    shell(:no_resize) {
      text 'Glimmer Tetris'
      background :gray
      
      # TODO implement scoring
      # TODO implement showing upcoming shape
      # TODO implement differnet difficulty levels
      composite {
        grid_layout(PLAYFIELD_WIDTH, true) {
          margin_width BLOCK_SIZE
          margin_height BLOCK_SIZE
          horizontal_spacing 0
          vertical_spacing 0
        }
        
        PLAYFIELD_HEIGHT.times { |row|
          PLAYFIELD_WIDTH.times { |column|
            block(block_size: BLOCK_SIZE, row: row, column: column)
          }
        }
      }
    }
  }
end

Tetris.launch
