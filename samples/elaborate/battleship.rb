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
require 'facets/string/titlecase'
require 'facets/string/underscore'

require_relative 'battleship/model/game'

require_relative 'battleship/view/grid'
require_relative 'battleship/view/ship_collection'
require_relative 'battleship/view/action_panel'

class Battleship
  include Glimmer::UI::CustomShell

  COLOR_WATER = rgb(156, 211, 219)
  COLOR_SHIP = :dark_gray
  
  before_body do
    @game = Model::Game.new
  end
    
  after_body do
    observe(@game, :over) do |game_over_value|
      if game_over_value
        game_over_message = if game_over_value == :you
          "Game over!\nYou Won!"
        else
          "Game over!\nYou Lost!"
        end
        
        message_box {
          text 'Game Over!'
          message game_over_message
        }.open
      end
    end
  end
  
  body {
    shell(:no_resize) {
      grid_layout(2, false) {
        horizontal_spacing 15
        vertical_spacing 15
      }
      
      text 'Glimmer Battleship'

      @enemy_grid = grid(game: @game, player: :enemy)
      @enemy_ship_collection = ship_collection(game: @game, player: :enemy)
      
      @player_grid = grid(game: @game, player: :you)
      @player_ship_collection = ship_collection(game: @game, player: :you)

      action_panel(game: @game)
    }
  }
end

Battleship.launch
