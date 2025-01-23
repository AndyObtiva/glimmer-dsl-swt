# Copyright (c) 2007-2025 Andy Maleh
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

require_relative '../model/grid'

require_relative 'cell'

class Battleship
  module View
    class Grid
      include Glimmer::UI::CustomWidget
      
      options :game, :player
      
      body {
        composite {
          grid_layout(Model::Grid::WIDTH + 1, true) {
            margin_width 0
            margin_height 0
            horizontal_spacing 0
            vertical_spacing 0
          }
    
          label(:center) {
            layout_data(:fill, :center, true, false) {
              horizontal_span (Model::Grid::WIDTH + 1)
            }
            
            text player.to_s.capitalize
            font height: OS.windows? ? 18 : 20, style: :bold
          }
          
          label # filler
          Model::Grid::WIDTH.times do |column_index|
            label {
              text (column_index + 1).to_s
              font height: OS.windows? ? 14 : 16
            }
          end
          
          Model::Grid::HEIGHT.times do |row_index|
            label {
              text Model::Grid::ROW_ALPHABETS[row_index]
              font height: OS.windows? ? 14 : 16
            }
            Model::Grid::WIDTH.times do |column_index|
              cell(game: game, player: player, row_index: row_index, column_index: column_index) {
                layout_data {
                  width_hint 25
                  height_hint 25
                }
              }
            end
          end
        }
      }
    end
  end
end
