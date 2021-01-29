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
    class Block
      include Glimmer::UI::CustomWidget
  
      options :game_playfield, :block_size, :row, :column
  
      before_body {
        @bevel_constant = 20
      }
  
      body {
        canvas {
          background bind(game_playfield[row][column], :color)
          polygon(0, 0, block_size, 0, block_size - 4, 4, 4, 4, fill: true) {
            background bind(game_playfield[row][column], :color) { |color_value|
              color = color(color_value)
              rgb(color.red + 4*@bevel_constant, color.green + 4*@bevel_constant, color.blue + 4*@bevel_constant)
            }
          }
          polygon(block_size, 0, block_size - 4, 4, block_size - 4, block_size - 4, block_size, block_size, fill: true) {
            background bind(game_playfield[row][column], :color) { |color_value|
              color = color(color_value)
              rgb(color.red - @bevel_constant, color.green - @bevel_constant, color.blue - @bevel_constant)
            }
          }
          polygon(block_size, block_size, 0, block_size, 4, block_size - 4, block_size - 4, block_size - 4, fill: true) {
            background bind(game_playfield[row][column], :color) { |color_value|
              color = color(color_value)
              rgb(color.red - 2*@bevel_constant, color.green - 2*@bevel_constant, color.blue - 2*@bevel_constant)
            }
          }
          polygon(0, 0, 0, block_size, 4, block_size - 4, 4, 4, fill: true) {
            background bind(game_playfield[row][column], :color) { |color_value|
              color = color(color_value)
              rgb(color.red - @bevel_constant, color.green - @bevel_constant, color.blue - @bevel_constant)
            }
          }
          rectangle(0, 0, block_size, block_size) {
            foreground bind(game_playfield[row][column], :color) { |color_value|
              color_value == Model::Block::COLOR_CLEAR ? :gray : color_value
            }
          }
        }
      }
    end
  end
end
