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

require_relative 'klondike_solitaire/model/game'

require_relative 'klondike_solitaire/view/action_panel'
require_relative 'klondike_solitaire/view/tableau'
require_relative 'klondike_solitaire/view/klondike_solitaire_menu_bar'

class KlondikeSolitaire
  include Glimmer::UI::CustomShell
  
  PLAYING_CARD_WIDTH = 50
  PLAYING_CARD_HEIGHT = 76
  PLAYING_CARD_SPACING = 5
  PLAYING_CARD_FONT_HEIGHT = 16
  MARGIN = 15
  TABLEAU_WIDTH = 2*MARGIN + 7*(PLAYING_CARD_WIDTH + PLAYING_CARD_SPACING)
  TABLEAU_HEIGHT = 420

  before_body do
    @game = Model::Game.new
  end

  body {
    shell {
      grid_layout {
        margin_width 0
        margin_height 0
        margin_top 15
      }
      minimum_size TABLEAU_WIDTH, TABLEAU_HEIGHT
      text "Glimmer Klondike Solitaire"
      background :dark_green
    
      klondike_solitaire_menu_bar(game: @game)
    
      action_panel(game: @game) {
        layout_data(:fill, :center, true, false)
      }
      
      tableau(game: @game) {
        layout_data(:fill, :fill, true, true) {
          width_hint TABLEAU_WIDTH
          height_hint TABLEAU_HEIGHT
        }
      }
    }
  }
end

KlondikeSolitaire.launch
