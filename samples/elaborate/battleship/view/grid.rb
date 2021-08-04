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

require 'glimmer-dsl-swt'

require_relative '../model/game'

class Battleship
  module View
    class Grid
      include Glimmer::UI::CustomWidget
      
      COLOR_WATER = rgb(156, 211, 219)
      COLOR_SHIP = :dark_gray
      ROW_ALPHABETS = %w[A B C D E F G H I J]
      
      options :game, :type
      
      body {
        composite {
          grid_layout(Model::Game::WIDTH + 1, true) {
            margin_width 0
            margin_height 0
          }
    
          label(:center) {
            layout_data(:fill, :center, true, false) {
              horizontal_span (Model::Game::WIDTH + 1)
            }
            
            text type == :player ? 'You' : 'Enemy'
            font height: 20, style: :bold
          }
          
          label # filler
          Model::Game::WIDTH.times do |column_index|
            label {
              text (column_index + 1).to_s
              font height: 16
            }
          end
          
          Model::Game::HEIGHT.times do |row_index|
            label {
              text ROW_ALPHABETS[row_index]
              font height: 16
            }
            Model::Game::WIDTH.times do |column_index|
              canvas {
                layout_data {
                  width_hint 25
                  height_hint 25
                }
                
                background COLOR_WATER
                
                rectangle(0, 0, [:max, -1], [:max, -1])
                oval(:default, :default, 10, 10)
                oval(:default, :default, 5, 5) {
                  background :black
                }
              }
            end
          end
        }
      }
    end
  end
end
