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

require_relative 'ship'

class Battleship
  module Model
    class ShipCollection
      BATTLESHIPS = {
        aircraft_carrier: 5,
        battleship: 4,
        submarine: 3,
        cruiser: 3,
        destroyer: 2
      }
      
      attr_reader :game, :player, :ships
      attr_accessor :placed_count
            
      def initialize(game, player)
        @game = game
        @player = player
        @ships = BATTLESHIPS.reduce({}) do |hash, pair|
          name, width = pair
          ship = Ship.new(self, name, width)
          Glimmer::DataBinding::Observer.proc do |cell_value|
            self.placed_count = self.placed_count.to_i + 1 if cell_value
          end.observe(ship, :cell)
          hash.merge(name => ship)
        end
      end
      
      def reset!
        ships.each(&:reset!)
      end
    end
  end
end
