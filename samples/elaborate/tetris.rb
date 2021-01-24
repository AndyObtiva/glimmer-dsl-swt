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

require 'jruby/profiler'
require_relative 'tetris/model/game'

require_relative 'tetris/view/playfield'
require_relative 'tetris/view/score_lane'
require_relative 'tetris/view/game_over_dialog'

class Tetris
  include Glimmer::UI::CustomShell
  
  BLOCK_SIZE = 25
  PLAYFIELD_WIDTH = 10
  PLAYFIELD_HEIGHT = 20
  PREVIEW_PLAYFIELD_WIDTH = 4
  PREVIEW_PLAYFIELD_HEIGHT = 2
  
  before_body {
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
        when 'd'.bytes.first, swt(:arrow_up)
          Model::Game.current_tetromino.rotate(:right)
        when 'a'.bytes.first
          Model::Game.current_tetromino.rotate(:left)
        end
      }
    }
    
    Model::Game.configure_beeper do
      async_exec {
        display.beep
      }
    end
  }
  
  after_body {
    Model::Game.start
    
    Thread.new {
      loop {
        sleep(Model::Game.delay)
        sync_exec {
          unless Model::Game.game_over?
            Model::Game.current_tetromino.down
            game_over_dialog(parent_shell: body_root).open if Model::Game.current_tetromino.row <= 0 && Model::Game.current_tetromino.stopped?
          end
        }
      }
    }
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
      background :gray
            
      playfield(game_playfield: Model::Game.playfield, playfield_width: PLAYFIELD_WIDTH, playfield_height: PLAYFIELD_HEIGHT, block_size: BLOCK_SIZE)
      
      score_lane(block_size: BLOCK_SIZE) {
        layout_data(:fill, :fill, false, true)
      }
      
      on_swt_show {
#         puts 'closing'
#         exit(0)
      }
    }
  }
end

# profile_data = JRuby::Profiler.profile do
  Tetris.launch
# end

# profile_printer = JRuby::Profiler::HtmlProfilePrinter.new(profile_data)
# ps = java.io.PrintStream.new(STDOUT.to_outputstream)
