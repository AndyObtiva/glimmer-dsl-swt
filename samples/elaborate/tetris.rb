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

class Tetris
  include Glimmer::UI::CustomShell
  
  BLOCK_SIZE = 25
  PLAYFIELD_WIDTH = 10
  PLAYFIELD_HEIGHT = 20
  
  before_body {
    Model::Game.configure_beeper do
      display.beep
    end
    
    Model::Game.start
    
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
    Thread.new {
      loop {
        sleep(1) # TODO make this configurable depending on level
        # TODO add processing delay for when stopped? status sticks so user can move block left and right still for a short period of time
        sync_exec {
          unless @game_over
            Model::Game.current_tetromino.down
            if Model::Game.current_tetromino.stopped? && Model::Game.current_tetromino.row <= 0
              # TODO extract to a declare_game_over method
              @game_over = true
              display.beep
              message_box(:icon_warning) {
                text 'Tetris'
                message 'Game Over!'
              }.open
              Model::Game.restart
              @game_over = false
            end
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
      
      playfield(playfield_width: PLAYFIELD_WIDTH, playfield_height: PLAYFIELD_HEIGHT, block_size: BLOCK_SIZE)
    }
  }
end

Tetris.launch
