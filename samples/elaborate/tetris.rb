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

# Tetris App View Custom Shell (represents `tetris` keyword)

require_relative 'tetris/model/game'

require_relative 'tetris/view/playfield'
require_relative 'tetris/view/score_lane'
require_relative 'tetris/view/game_over_dialog'
require_relative 'tetris/view/tetris_menu_bar'

class Tetris
  include Glimmer::UI::CustomShell
  
  BLOCK_SIZE = 25
  
  option :playfield_width, default: Model::Game::PLAYFIELD_WIDTH
  option :playfield_height, default: Model::Game::PLAYFIELD_HEIGHT
  
  attr_reader :game
  
  before_body {
    @mutex = Mutex.new
    @game = Model::Game.new(playfield_width, playfield_height)
        
    @game.configure_beeper do
      display.beep
    end
    
    Display.app_name = 'Glimmer Tetris'
    display {
      @keyboard_listener = on_swt_keydown { |key_event|
        case key_event.keyCode
        when swt(:arrow_down)
          game.down!
        when swt(:arrow_left)
          game.left!
        when swt(:arrow_right)
          game.right!
        when swt(:shift)
          if key_event.keyLocation == swt(:right) # right shift key
            game.rotate!(:right)
          elsif key_event.keyLocation == swt(:left) # left shift key
            game.rotate!(:left)
          end
        when 'd'.bytes.first, swt(:arrow_up)
          game.rotate!(:right)
        when 'a'.bytes.first
          game.rotate!(:left)
        end
      }
    }
  }
  
  after_body {
    @game_over_observer = observe(@game, :game_over) do |game_over|
      if game_over
        @game_over_dialog = game_over_dialog(parent_shell: body_root, game: @game) if @game_over_dialog.nil? || @game_over_dialog.disposed?
        @game_over_dialog.show
      else
        start_moving_tetrominos_down
      end
    end
    @game.start!
  }
  
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
      background :gray
      
      tetris_menu_bar(game: game)
            
      playfield(game_playfield: game.playfield, playfield_width: playfield_width, playfield_height: playfield_height, block_size: BLOCK_SIZE)
      
      score_lane(game: game, block_size: BLOCK_SIZE) {
        layout_data(:fill, :fill, true, true)
      }
      
      on_widget_disposed {
        deregister_observers
      }
    }
  }
  
  def start_moving_tetrominos_down
    Thread.new do
      @mutex.synchronize do
        loop do
          time = Time.now
          sleep @game.delay
          break if @game.game_over? || body_root.disposed?
          sync_exec {
            @game.down! unless @game.paused?
          }
        end
      end
    end
  end
  
  def deregister_observers
    @game_over_observer&.deregister
    @game_over_observer = nil
    @keyboard_listener&.deregister
    @keyboard_listener = nil
  end
end

Tetris.launch
