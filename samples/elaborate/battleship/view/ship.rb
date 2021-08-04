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

require_relative 'cell'

class Battleship
  module View
    class Ship
      include Glimmer::UI::CustomWidget
      
      options :game, :player, :ship_name, :ship_width
      
      body {
        composite {
          row_layout(:vertical) {
            fill true
            margin_width 0
            margin_height 0
          }
      
          label {
            text ship_name.to_s.titlecase
            font height: 16
          }
        
          composite {
            grid_layout(ship_width, true) {
              margin_width 0
              margin_height 0
              horizontal_spacing 0
              vertical_spacing 0
            }
            
            ship_width.times do |column_index|
              cell(game: game, player: player, type: :ship, column_index: column_index, ship: self) {
                layout_data {
                  width_hint 25
                  height_hint 25
                }
              }
            end
          }
        }
      }
    end
  end
end
