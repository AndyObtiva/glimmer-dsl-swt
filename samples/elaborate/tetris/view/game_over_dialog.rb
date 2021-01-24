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

class Tetris
  module View
    class GameOverDialog
      include Glimmer::UI::CustomShell
  
      options :parent_shell
      
      body {
        dialog(parent_shell) {
          row_layout {
            type :vertical
            center true
          }
          text 'Tetris'
          
          label(:center) {
            text 'Game Over!'
            font name: 'Menlo', height: 30, style: :bold
          }
          label # filler
          button {
            text 'Play Again?'
            
            on_widget_selected {
              Model::Game.restart
              
              body_root.close
            }
          }
          
          on_shell_activated {
            Model::Game.game_over = true
            display.beep
          }
          
          on_shell_closed {
            exit_game
          }
          
          on_key_pressed { |event|
            exit_game if event.keyCode == swt(:cr)
          }
        }
      }
      
      def exit_game
        display.dispose if Model::Game.game_over?
      end
    end
  end
end
