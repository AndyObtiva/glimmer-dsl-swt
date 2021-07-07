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

require_relative 'tetris_menu_bar'

class Tetris
  module View
    class HighScoreDialog
      include Glimmer::UI::CustomShell
  
      options :parent_shell, :game
      
      after_body {
        @game_over_observer = observe(game, :game_over) do |game_over|
          close if !game_over
        end
      }
      
      body {
        dialog(parent_shell) {
          row_layout {
            type :vertical
            center true
          }
          text 'Glimmer Tetris'
          
          tetris_menu_bar(game: game)
          
          label(:center) {
            text <= [game, :game_over, on_read: ->(game_over) { game_over ? 'Game Over!' : 'High Scores' }]
            font name: FONT_NAME, height: FONT_TITLE_HEIGHT, style: FONT_TITLE_STYLE
          }
          @high_score_table = table {
            layout_data {
              height 100
            }
            
            table_column {
              text 'Name'
            }
            table_column {
              text 'Score'
            }
            table_column {
              text 'Lines'
            }
            table_column {
              text 'Level'
            }
            
            items <=> [game, :high_scores, read_only_sort: true, column_properties: [:name, :score, :lines, :level]]
          }
          composite {
            row_layout :horizontal
                        
            @play_close_button = button {
              text <= [game, :game_over, on_read: ->(game_over) { game_over ? 'Play Again?' : 'Close'}]
              focus true # initial focus
              
              on_widget_selected {
                async_exec { close }
                game.paused = @game_paused
                game.restart! if game.game_over?
              }
            }
          }
          
          on_swt_show {
            @game_paused = game.paused?
            game.paused = true
            if game.game_over? && game.added_high_score?
              game.added_high_score = false
              game.save_high_scores!
              @high_score_table.edit_table_item(
                @high_score_table.items.first, # row item
                0, # column
                write_on_cancel: true,
                after_write: -> {
                  game.save_high_scores!
                  @play_close_button.set_focus
                },
              )
            end
          }
          
          on_shell_closed {
            # guard is needed because there is an observer in Tetris closing on
            # game.show_high_scores change, which gets set below
            unless @closing
              @closing = true
              @high_score_table.cancel_edit!
              game.paused = @game_paused
              game.show_high_scores = false
            else
              @closing = false
            end
          }
          
          on_widget_disposed {
            @game_over_observer.deregister
          }
        }
      }
    end
  end
end
