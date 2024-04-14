# Copyright (c) 2007-2024 Andy Maleh
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

require_relative 'grid'
require_relative 'ship'

class Battleship
  module Model
    class Game
      BATTLESHIPS = {
        aircraft_carrier: 5,
        battleship: 4,
        submarine: 3,
        cruiser: 3,
        destroyer: 2
      }
      PLAYERS = [:enemy, :you]
      
      attr_reader :grids, :ship_collections
      attr_accessor :started, :current_player, :over
      alias started? started
      alias over? over
            
      def initialize
        @grids = PLAYERS.reduce({}) { |hash, player| hash.merge(player => Grid.new(self, player)) }
        @ship_collections = PLAYERS.reduce({}) { |hash, player| hash.merge(player => ShipCollection.new(self, player)) }
        @started = false
        @current_player = :enemy
        @enemy_moves = []
      end
      
      def battle!
        self.started = true
        place_enemy_ships!
        enemy_attack!
      end
      
      def reset!
        self.started = false
        self.over = false
        self.current_player = :enemy
        @grids.values.each(&:reset!)
        @ship_collections.values.each(&:reset!)
        @enemy_moves = []
      end
      
      def attack!(row_index, column_index)
        return unless started?
        cell = opposite_grid.cell_rows[row_index][column_index]
        return unless cell.hit.nil?
        cell.hit = !!cell.ship
        switch_player!
        enemy_attack! if current_player == :enemy
      end
      
      # Enemy attack artificial intelligence
      def enemy_attack!
        begin
          cell = nil
          if @enemy_moves.any? && @enemy_moves.last.hit? && !@enemy_moves.last.ship.sunk?
            if @enemy_moves[-2].nil? || !@enemy_moves[-2].hit?
              orientation = Ship::ORIENTATIONS[(rand * 2).to_i]
            else
              orientation = @enemy_moves.last.row_index == @enemy_moves[-2].row_index ? :horizontal : :vertical
            end
            offset = 1 * ((rand * 2).to_i == 1 ? 1 : -1)
            if orientation == :horizontal
              offset *= -1 if [-1, Grid::WIDTH].include?(@enemy_moves.last.column_index + offset)
              cell = opposite_grid.cell_rows[@enemy_moves.last.row_index][@enemy_moves.last.column_index + offset]
            else
              offset *= -1 if [-1, Grid::HEIGHT].include?(@enemy_moves.last.row_index + offset)
              cell = opposite_grid.cell_rows[@enemy_moves.last.row_index + offset][@enemy_moves.last.column_index]
            end
            cell = nil if cell.hit?
          end
          if cell.nil?
            random_row_index = (rand * Grid::HEIGHT).to_i
            random_column_index = (rand * Grid::WIDTH).to_i
            cell = opposite_grid.cell_rows[random_row_index][random_column_index]
          end
        end until cell.hit.nil?
        attack!(cell.row_index, cell.column_index)
        @enemy_moves << cell
      end
      
      def opposite_grid
        grids[opposite_player]
      end
      
      def opposite_player(player = nil)
        player ||= current_player
        PLAYERS[(PLAYERS.index(player) + 1) % PLAYERS.size]
      end
      
      def switch_player!
        self.current_player = opposite_player
      end
      
      def over=(value)
        @over = value
        self.started = false
      end
      
      private
      
      def place_enemy_ships!
        ship_collection = @ship_collections[:enemy]
        ship_collection.ships.values.each do |ship|
          until ship.top_left_cell
            random_row_index = (rand * Grid::HEIGHT).to_i
            random_column_index = (rand * Grid::WIDTH).to_i
            enemy_grid = @grids[:enemy]
            top_left_cell = enemy_grid.cell_rows[random_row_index][random_column_index]
            top_left_cell.place_ship!(ship)
            begin
              ship.toggle_orientation! if (rand * 2).to_i == 1
            rescue => e
              Glimmer::Config.logger.debug(e.full_message)
            end
          end
        end
      end
    end
  end
end
