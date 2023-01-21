# Copyright (c) 2007-2023 Andy Maleh
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

class Battleship
  module View
    class ActionPanel
      include Glimmer::UI::CustomWidget
      
      options :game
      
      body {
        composite {
          row_layout(:horizontal) {
            margin_width 0
            margin_height 0
          }
          
          layout_data(:center, :center, true, false)
                  
          @battle_button = button {
            text 'Battle!'
            enabled <= [game.ship_collections[:you], :placed_count, on_read: ->(c) {c == 5}]
            
            on_widget_selected do
              game.battle!
              @battle_button.enabled = false
            end
          }
                  
          button {
            text 'Restart'
            
            on_widget_selected do
              game.reset!
            end
          }
        }
      }
    end
  end
end
