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

require_relative 'block'

class Tetris
  module View
    class Playfield
      include Glimmer::UI::CustomWidget
  
      options :game_playfield, :playfield_width, :playfield_height, :block_size
  
      body {
        canvas {
          grid_layout {
            num_columns playfield_width
            make_columns_equal_width true
            margin_width block_size
            margin_height block_size
            horizontal_spacing 0
            vertical_spacing 0
          }

          playfield_height.times { |row|
            playfield_width.times { |column|
              block(game_playfield: game_playfield, block_size: block_size, row: row, column: column) {
                layout_data {
                  width_hint block_size
                  height_hint block_size
                }
              }
            }
          }
        }
      }
    end
  end
end
