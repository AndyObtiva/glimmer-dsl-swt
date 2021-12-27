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

require_relative 'quarto/model/game'
require_relative 'quarto/view/board'
require_relative 'quarto/view/available_pieces_area'
require_relative 'quarto/view/selected_piece_area'

class Quarto
  include Glimmer::UI::CustomShell
  
  BOARD_DIAMETER = 430
  PIECES_AREA_WIDTH = 230
  PIECES_AREA_HEIGHT = 270
  CELL_DIAMETER = 68
  CELL_LINE_WIDTH = 5
  CELL_MARGIN = 7
  ROW_COUNT = 4
  COLUMN_COUNT = 4
  COLOR_WOOD = rgb(239, 196, 156)
  COLOR_AREA = rgb(206, 188, 170)
  
  before_body do
    @game = Model::Game.new
  end

  body {
    shell {
      grid_layout(2, false) {
        margin_width 0
        margin_height 0
        horizontal_spacing 0
      }
      
      text 'Glimmer Quarto'
      minimum_size BOARD_DIAMETER + PIECES_AREA_WIDTH, BOARD_DIAMETER + 24
      maximum_size BOARD_DIAMETER + PIECES_AREA_WIDTH, BOARD_DIAMETER + 24
      background COLOR_WOOD
      
      composite {
        layout_data(:fill, :fill, true, true) {
          width_hint BOARD_DIAMETER
          height_hint BOARD_DIAMETER
          vertical_span 2
        }
        
        background COLOR_WOOD
        
        board
      }
      
      canvas {
        layout_data(:fill, :fill, true, true) {
          width_hint PIECES_AREA_WIDTH
          height_hint PIECES_AREA_HEIGHT
        }
        
        background COLOR_WOOD
        
        available_pieces_area(game: @game)
      }
      
      canvas {
        layout_data(:fill, :fill, true, true) {
          width_hint PIECES_AREA_WIDTH
          height_hint PIECES_AREA_HEIGHT / 2.0
        }
        
        background COLOR_WOOD
        
        selected_piece_area(game: @game)
      }
    }
  }
end

Quarto.launch
