# Copyright (c) 2007-2022 Andy Maleh
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

class GameOfLife
  include Glimmer::UI::CustomShell
  
  WIDTH = 20
  HEIGHT = 20
  CELL_WIDTH = 25
  CELL_HEIGHT = 25
  
  before_body do
    @grid = GameOfLife::Model::Grid.new(WIDTH, HEIGHT)
  end
  
  body {
    shell {
      row_layout :vertical
      text "Conway's Game of Life (Glimmer Edition)"
    
      canvas {
        layout_data {
          width WIDTH*CELL_WIDTH
          height HEIGHT*CELL_HEIGHT
        }
        (0...HEIGHT).each do |row_index|
          (0...WIDTH).each do |column_index|
            rectangle(column_index*CELL_WIDTH, row_index*CELL_HEIGHT, CELL_WIDTH, CELL_HEIGHT) {
              background <= [@grid.cell_rows[row_index][column_index], :alive, on_read: ->(a) {a ? :black : :white}]
              
              on_mouse_down do
                @grid.cell_rows[row_index][column_index].toggle_aliveness!
              end
              
              on_drag_detected do
                @drag_detected = true
              end

              on_mouse_move do
                @grid.cell_rows[row_index][column_index].live! if @drag_detected
              end

              on_mouse_up do
                @drag_detected = false
              end
            }
          end
        end
      }
        
      composite {
        row_layout(:horizontal) {
          margin_width 0
        }
                
        button {
          text 'Step'
          enabled <= [@grid, :playing, on_read: :! ]
          
          on_widget_selected do
            @grid.step!
          end
        }
        
        button {
          text 'Clear'
          enabled <= [@grid, :playing, on_read: :! ]
          
          on_widget_selected do
            @grid.clear!
          end
        }
                
        button {
          text <= [@grid, :playing, on_read: ->(p) { p ? 'Stop' : 'Play' }]
          
          on_widget_selected do
            @grid.toggle_playback!
          end
        }
  
        label {
          text 'Slower'
        }
              
        scale {
          minimum 1
          maximum 100
          selection <=> [@grid, :speed]
        }
          
        label {
          text 'Faster'
        }
          
      }
    }
  }
end

GameOfLife.launch
