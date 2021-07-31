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

require 'glimmer-dsl-swt'

require_relative 'tetris/model/game'

require_relative 'tetris/view/playfield'
require_relative 'tetris/view/score_lane'
require_relative 'tetris/view/high_score_dialog'
require_relative 'tetris/view/tetris_menu_bar'

# Tetris App View Custom Shell (represents `tetris` keyword)
class Tetris
  include Glimmer::UI::CustomShell
  
  BLOCK_SIZE = 25
  FONT_NAME = 'Menlo'
  FONT_TITLE_HEIGHT = 32
  FONT_TITLE_STYLE = :bold
  BEVEL_CONSTANT = 20
  
  option :playfield_width, default: Model::Game::PLAYFIELD_WIDTH
  option :playfield_height, default: Model::Game::PLAYFIELD_HEIGHT
  
  attr_reader :game
  
  before_body do
    @mutex = Mutex.new
    @game = Model::Game.new(playfield_width, playfield_height)
        
    @game.configure_beeper do
      display.beep
    end
    
    Display.app_name = 'Glimmer Tetris'

    display {
      on_swt_keydown { |key_event|
        case key_event.keyCode
        when swt(:arrow_down), 's'.bytes.first
          game.down! if OS.mac?
        when swt(:arrow_up)
          case game.up_arrow_action
          when :instant_down
            game.down!(instant: true)
          when :rotate_right
            game.rotate!(:right)
          when :rotate_left
            game.rotate!(:left)
          end
        when swt(:arrow_left), 'a'.bytes.first
          game.left!
        when swt(:arrow_right), 'd'.bytes.first
          game.right!
        when swt(:shift), swt(:alt)
          if key_event.keyLocation == swt(:right) # right shift key
            game.rotate!(:right)
          elsif key_event.keyLocation == swt(:left) # left shift key
            game.rotate!(:left)
          end
        end
      }

      # invoke game.down! on keyup with Windows/Linux since they seem to group-render similar events, preventing intermediate renders (causing invisiblity while holding keys)
      if !OS.mac?
        on_swt_keyup { |key_event|
          case key_event.keyCode
          when swt(:arrow_down), 's'.bytes.first
            game.down!
          end
        }
      end
      
      # if running in app mode, set the Mac app about dialog (ignored in platforms)
      on_about {
        show_about_dialog
      }
      
      on_quit {
        exit(0)
      }
    }
  end
  
  after_body do
    observe(@game, :game_over) do |game_over|
      if game_over
        show_high_score_dialog
      else
        start_moving_tetrominos_down
      end
    end
    observe(@game, :show_high_scores) do |show_high_scores|
      if show_high_scores
        show_high_score_dialog
      else
        @high_score_dialog.close unless @high_score_dialog.nil? || @high_score_dialog.disposed? || !@high_score_dialog.visible?
      end
    end
    @game.start!
  end
  
  body {
    shell(:no_resize) {
      grid_layout {
        num_columns 2
        make_columns_equal_width false
        margin_width 0
        margin_height 0
        horizontal_spacing 0
      }
      
      text 'Glimmer Tetris'
      minimum_size 475, 500
      image tetris_icon

      tetris_menu_bar(game: game)

      playfield(game_playfield: game.playfield, playfield_width: playfield_width, playfield_height: playfield_height, block_size: BLOCK_SIZE)

      score_lane(game: game, block_size: BLOCK_SIZE) {
        layout_data(:fill, :fill, true, true)
      }
    }
  }
  
  def tetris_icon
    icon_block_size = 64
    icon_bevel_size = icon_block_size.to_f / 25.to_f
    icon_bevel_pixel_size = 0.16*icon_block_size.to_f
    icon_size = 8
    icon_pixel_size = icon_block_size * icon_size
    image(icon_pixel_size, icon_pixel_size) {
      icon_size.times { |row|
        icon_size.times { |column|
          colored = row >= 1 && column.between?(1, 6)
          color = colored ? color(([:white] + Model::Tetromino::LETTER_COLORS.values).sample) : color(:white)
          x = column * icon_block_size
          y = row * icon_block_size
          bevel(x: x, y: y, base_color: color, size: icon_block_size)
        }
      }
    }
  end

  def start_moving_tetrominos_down
    Thread.new do
      @mutex.synchronize do
        loop do
          time = Time.now
          sleep @game.delay
          break if @game.game_over? || body_root.disposed?
          # ensure entire game tetromino down movement happens as one GUI update event with sync_exec (to avoid flicker/stutter)
          sync_exec {
            @game.down! unless @game.paused?
          }
        end
      end
    end
  end
  
  def show_high_score_dialog
    return if @high_score_dialog&.visible?
    @high_score_dialog = high_score_dialog(parent_shell: body_root, game: @game) if @high_score_dialog.nil? || @high_score_dialog.disposed?
    @high_score_dialog.show
  end
  
  def show_about_dialog
    message_box {
      text 'Glimmer Tetris'
      message "Glimmer Tetris\n\nGlimmer DSL for SWT Sample\n\nCopyright (c) 2007-2021 Andy Maleh"
    }.open
  end
end

Tetris.launch
