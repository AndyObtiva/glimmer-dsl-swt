require 'glimmer-dsl-swt'

require_relative 'klondike_solitaire/model/game'

require_relative 'klondike_solitaire/view/action_panel'
require_relative 'klondike_solitaire/view/tableau'
require_relative 'klondike_solitaire/view/klondike_solitaire_menu_bar'

class KlondikeSolitaire
  include Glimmer::UI::CustomShell
  
  PLAYING_CARD_WIDTH = 50
  PLAYING_CARD_HEIGHT = 80
  PLAYING_CARD_SPACING = 5
  MARGIN = 15
  TABLEAU_WIDTH = 2*MARGIN + 7*(PLAYING_CARD_WIDTH + PLAYING_CARD_SPACING)
  TABLEAU_HEIGHT = 400

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
