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

require_relative 'game_of_life/model/grid'

width = 7
height = 7
grid = GameOfLife::Model::Grid.new(width, height)

include Glimmer

shell {
  text "Conway's Game of Life (Glimmer Edition)"
  composite {
    grid_layout width, true
    
    (0...height).each do |row_index|
      (0...width).each do |column_index|
        cell =
        button(:toggle) {
          layout_data :fill, :fill, true, true
          
          selection <= [grid.cell_rows[row_index][column_index], "alive"]
          
          on_widget_selected {
            grid.cell_rows[row_index][column_index].toggle_aliveness!
          }
        }
      end
    end
    
    button {
      text "Step"
      on_widget_selected {
        grid.step!
      }
    }
  }
}.open
