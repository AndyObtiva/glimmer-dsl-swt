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
require_relative 'tetris/view/game_over_dialog'

class Tetris
  include Glimmer::UI::CustomShell
  
  BLOCK_SIZE = 25
  PLAYFIELD_WIDTH = 10
  PLAYFIELD_HEIGHT = 20
  
  before_body {
    Model::Game.configure_beeper do
      display.beep
    end
        
    display {
      on_swt_keydown { |key_event|
        case key_event.keyCode
        when swt(:arrow_down)
          Model::Game.current_tetromino.down
        when swt(:arrow_left)
          Model::Game.current_tetromino.left
        when swt(:arrow_right)
          Model::Game.current_tetromino.right
        when swt(:shift)
          if key_event.keyLocation == swt(:right) # right shift key
            Model::Game.current_tetromino.rotate(:right)
          elsif key_event.keyLocation == swt(:left) # left shift key
            Model::Game.current_tetromino.rotate(:left)
          end
        when 'd'.bytes.first, swt(:arrow_up) # TODO consider changing up button to immediate drop
          Model::Game.current_tetromino.rotate(:right)
        when 'a'.bytes.first
          Model::Game.current_tetromino.rotate(:left)
        end
      }
    }
  }
  
  after_body {
    Model::Game.start
    
    Thread.new {
      loop {
#         break if @game_over # TODO exit out of loop/thread once game is over
        sleep(1) # TODO make this configurable depending on level
        # TODO add processing delay for when stopped? status sticks so user can move block left and right still for a short period of time
        sync_exec {
          unless Model::Game.game_over?
            Model::Game.current_tetromino.down
            game_over_dialog.open if Model::Game.current_tetromino.row <= 0 && Model::Game.current_tetromino.stopped?
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
      # TODO implement eliminated line tracking
      # TODO implement level tracking
      # TODO implement showing upcoming shape
      # TODO implement differnet difficulty levels
      # TODO add an about dialog
      # TODO add a menu
      # TODO consider adding music via JSound
      # TODO refactor mutation methods to use bang
      # TODO consider idea of painting my own icon with Glimmer canvas and setting on Shell
      
      playfield(playfield_width: PLAYFIELD_WIDTH, playfield_height: PLAYFIELD_HEIGHT, block_size: BLOCK_SIZE)
    }
  }
end

Tetris.launch
