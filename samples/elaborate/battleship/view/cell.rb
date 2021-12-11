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
      COLOR_SHIP = :gray
      COLOR_PLACED = :white
      COLOR_EMPTY = :black
      COLOR_NO_HIT = :white
      COLOR_HIT = :red
      
      options :game, :player, :row_index, :column_index, :ship
      option :type, default: :grid # other type is :ship
      
      body {
        canvas {
          if type == :grid
            if player == :you
              background <= [model, :ship, on_read: ->(s) {s ? COLOR_SHIP : COLOR_WATER}]
            else
              background COLOR_WATER
            end
          else
            background <= [ship, :sunk, on_read: ->(s) {s ? COLOR_HIT : COLOR_PLACED}]
            background <= [ship, :top_left_cell, on_read: ->(c) {c ? COLOR_PLACED : COLOR_SHIP}]
          end
          
          rectangle(0, 0, [:max, -1], [:max, -1])
          oval(:default, :default, 10, 10) {
            if model.nil?
              foreground COLOR_EMPTY
            else
              foreground <= [model, :hit, on_read: ->(h) {h == nil ? COLOR_EMPTY : (h ? COLOR_HIT : COLOR_NO_HIT)}]
            end
          }
          oval(:default, :default, 5, 5) {
            if model.nil?
              background COLOR_EMPTY
            else
              background <= [model, :hit, on_read: ->(h) {h == nil ? COLOR_EMPTY : (h ? COLOR_HIT : COLOR_NO_HIT)}]
            end
          }
          
          on_mouse_move do |event|
            if game.started?
              if type == :grid
                if player == :enemy
                  body_root.cursor = :cross
                else
                  body_root.cursor = :arrow
                end
              else
                body_root.cursor = :arrow
              end
            end
          end
                    
          if player == :enemy
            on_mouse_up do
              game.attack!(row_index, column_index)
            end
          end
          
          if player == :you
            on_drag_detected do |event|
              unless game.started? || game.over?
                Cell.dragging = true
                body_root.cursor = :hand if type == :grid
              end
            end
          
            on_drag_set_data do |event|
              the_ship = ship || model&.ship
              if the_ship && !game.started? && !game.over? && !(type == :ship && the_ship.top_left_cell)
                event.data = the_ship.name.to_s
              else
                event.doit = false
                Cell.dragging = false
              end
            end
            
            on_mouse_up do
              unless game.started? || game.over?
                Cell.dragging = false
                change_cursor
              end
            end
                        
            if type == :grid
              on_mouse_move do |event|
                unless game.started? || game.over?
                  change_cursor
                end
              end
              
              on_mouse_hover do |event|
                unless game.started? || game.over?
                  change_cursor
                end
              end
              
              on_mouse_up do |event|
                unless game.started? || game.over?
                  begin
                    model.ship&.toggle_orientation!
                  rescue => e
                    Glimmer::Config.logger.debug e.full_message
                  end
                  change_cursor
                end
              end
              
              on_drop do |event|
                unless game.started? || game.over?
                  ship_name = event.data
                  place_ship(ship_name.to_s.to_sym) if ship_name
                  Cell.dragging = false
                  change_cursor
                end
              end
            end
          end
        }
      }
      
      def model
        game.grids[player].cell_rows[row_index][column_index] if type == :grid
      end
      
      def place_ship(ship_name)
        ship = game.ship_collections[player].ships[ship_name]
        model.place_ship!(ship)
      end
      
      def change_cursor
        if type == :grid && model.ship && !Cell.dragging?
          body_root.cursor = model.ship.orientation == :horizontal ? :sizens : :sizewe
        elsif !Cell.dragging?
          body_root.cursor = :arrow
        end
      end
    end
  end
end
