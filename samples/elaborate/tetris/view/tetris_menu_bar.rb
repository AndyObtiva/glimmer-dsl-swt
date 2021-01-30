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
    class TetrisMenuBar
      include Glimmer::UI::CustomWidget
  
      options :game
      
      body {
        menu_bar {
          menu {
            text '&Game'
            
            menu_item {
              text '&Start'
              enabled bind(game, :game_over)
              accelerator :command, :s
              
              on_widget_selected {
                game.start!
              }
            }
            menu_item(:check) {
              text '&Pause'
              accelerator :command, :p
              enabled bind(game, :game_over, on_read: :!) {|value| value && !game.show_high_scores}
              enabled bind(game, :show_high_scores, on_read: :!) {|value| value && !game.game_over}
              selection bind(game, :paused)
            }
            menu_item {
              text '&Restart'
              accelerator :command, :r
              
              on_widget_selected {
                game.restart!
              }
            }
            menu_item(:separator)
            menu_item {
              text '&Exit'
              accelerator :command, :x
              
              on_widget_selected {
                parent_proxy.close
              }
            }
          } # end of menu
          
          menu {
            text '&View'
            
            menu {
              text '&High Scores'
              menu_item(:check) {
                text '&Show'
                accelerator :command, :shift, :h
                selection bind(game, :show_high_scores)
              }
              menu_item {
                text '&Clear'
                accelerator :command, :shift, :c
                
                on_widget_selected {
                  game.clear_high_scores!
                }
              }
            }
          } # end of menu
          
          menu {
            text '&Options'
            menu_item(:check) {
              text '&Beeping'
              accelerator :command, :b
              selection bind(game, :beeping)
            }
            menu {
              text 'Up Arrow'
              menu_item(:radio) {
                text '&Instant Down'
                accelerator :command, :shift, :i
                selection bind(game, :instant_down_on_up, computed_by: :up_arrow_action)
              }
              menu_item(:radio) {
                text 'Rotate &Right'
                accelerator :command, :shift, :r
                selection bind(game, :rotate_right_on_up, computed_by: :up_arrow_action)
              }
              menu_item(:radio) {
                text 'Rotate &Left'
                accelerator :command, :shift, :l
                selection bind(game, :rotate_left_on_up, computed_by: :up_arrow_action)
              }
            }
          } # end of menu
          
          menu {
            text '&Help'
            
            menu_item {
              text '&About'
              accelerator :command, :shift, :a
              
              on_widget_selected {
                parent_custom_shell&.show_about_dialog
              }
            }
          } # end of menu
        }
      }
      
      def parent_custom_shell
        # grab custom shell widget wrapping parent widget proxy (i.e. Tetris) and invoke method on it
        the_parent_custom_shell = parent_proxy&.get_data('custom_shell')
        the_parent_custom_shell if the_parent_custom_shell&.visible?
      end
    end
  end
end
