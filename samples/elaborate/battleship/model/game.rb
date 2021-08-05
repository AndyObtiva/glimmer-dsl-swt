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

require_relative 'grid'

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
      attr_accessor :started
      alias started? started
            
      def initialize
        @grids = PLAYERS.reduce({}) { |hash, player| hash.merge(player => Grid.new(self, player)) }
        @ship_collections = PLAYERS.reduce({}) { |hash, player| hash.merge(player => ShipCollection.new(self, player)) }
      end
      
      def battle!
        self.started = true
      end
      
      def reset!
        self.started = false
        @grids.values.each(&:reset!)
        @ship_collections.values.each(&:reset!)
      end
    end
  end
end
