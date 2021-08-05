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

class Battleship
  module View
    class Cell
      include Glimmer::UI::CustomWidget
      
      class << self
        attr_accessor :dragging
        alias dragging? dragging
      end
      
      COLOR_WATER = rgb(156, 211, 219)
      COLOR_SHIP = :dark_gray
      COLOR_PLACED = :gray
      
      options :game, :player, :row_index, :column_index, :ship
      option :type, default: :grid # other type is :ship
      
      body {
        canvas {
          if type == :grid
            background <= [game.grids[player].cell_rows[row_index][column_index], :ship, on_read: ->(s) {s ? COLOR_SHIP : COLOR_WATER}]
          else
            background <= [ship, :cell, on_read: ->(c) {c ? :gray : COLOR_PLACED} ]
          end
          
          rectangle(0, 0, [:max, -1], [:max, -1])
          oval(:default, :default, 10, 10)
          oval(:default, :default, 5, 5) {
            background :black
          }
          
          if player == :you
            on_drag_set_data do |event|
              event.data = "#{player},#{ship.name}"
              Cell.dragging = true
            end
            
            on_mouse_up do
              Cell.dragging = false
            end
            
            on_mouse_enter do |event|
              body_root.background = :yellow if Cell.dragging?
            end
            
            on_mouse_exit do |event|
              body_root.background = type == :grid ? COLOR_WATER : COLOR_SHIP if Cell.dragging?
            end
            
            on_drop do |event|
              player, ship_name = event.data.split(',').map(&:to_sym)
              ship = game.ship_collections[player].ships[ship_name]
              begin
                ship.cell = game.grids[player].cell_rows[row_index][column_index]
                ship.length.times do |index|
                  cell = game.grids[player].cell_rows[row_index][column_index + index]
                  cell.ship = ship
                  cell.ship_index = index
                end
              rescue
                # No Op
              end
              Cell.dragging = false
            end
          end
        }
      }
    end
  end
end
