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

require_relative 'connect4/model/grid'

class Connect4
  include Glimmer::UI::CustomShell
  
  COLOR_BACKGROUND = rgb(63, 104, 212)
  COLOR_EMPTY_SLOT = :white
  COLOR_COIN1 = rgb(236, 223, 56)
  COLOR_COIN2 = rgb(176, 11, 23)
  
  attr_accessor :current_player_color
  
  before_body do
    @grid = Model::Grid.new
    select_player_color
  end
    
  after_body do
    observe(@grid, :current_player) do
      select_player_color
    end

    observe(@grid, :game_over) do |game_over_value|
      if game_over_value
        game_over_message = case game_over_value
        when true
          "Game over!\nDraw!"
        when 1
          "Game over!\nPlayer 1 (yellow) wins!"
        when 2
          "Game over!\nPlayer 2 (red) wins!"
        end
        
        message_box {
          text 'Game Over!'
          message game_over_message
        }.open
        
        @grid.restart!
      end
    end
  end
  
  body {
    shell(:no_resize) {
      grid_layout(Model::Grid::WIDTH, true)

      text 'Glimmer Connect 4'
      background COLOR_BACKGROUND
      
      Model::Grid::HEIGHT.times do |row_index|
        Model::Grid::WIDTH.times do |column_index|
          canvas {
            layout_data {
              width_hint 50
              height_hint 50
            }
            
            background :transparent
            
            the_oval = oval(0, 0, 50, 50) {
              background <= [@grid.slot_rows[row_index][column_index], :value, on_read: ->(v) { v == 0 ? COLOR_EMPTY_SLOT : (v == 1 ? COLOR_COIN1 : COLOR_COIN2)}]
            }
            
            if row_index == 0
              entered = false
              on_mouse_enter do
                entered = true
                the_oval.background = current_player_color if @grid.slot_rows[row_index][column_index].value == 0
              end
              
              on_mouse_exit do
                entered = false
                the_oval.background = COLOR_EMPTY_SLOT if @grid.slot_rows[row_index][column_index].value == 0
              end
              
              on_mouse_up do
                @grid.insert!(column_index)
                the_oval.background = current_player_color if entered && @grid.slot_rows[row_index][column_index].value == 0
              end
            end
          }
        end
      end
    }
  }
  
  def select_player_color
    self.current_player_color = @grid.current_player == 1 ? COLOR_COIN1 : COLOR_COIN2
  end
end

Connect4.launch
