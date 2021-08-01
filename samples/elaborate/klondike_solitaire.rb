require 'glimmer-dsl-swt'

require_relative 'klondike_solitaire/model/game'

require_relative 'klondike_solitaire/view/action_panel'
require_relative 'klondike_solitaire/view/tableau'

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
    Display.app_name = 'Glimmer Klondike Solitaire'
    @display = display {
      on_about {
        display_about_dialog
      }
      on_preferences {
        display_about_dialog
      }
    }
  end

  body {
    shell {
      row_layout(:vertical) {
        fill true
        center true
        margin_width 0
        margin_height 0
        margin_top 15
      }
      minimum_size TABLEAU_WIDTH, TABLEAU_HEIGHT
      text "Glimmer Klondike Solitaire"
      background :dark_green
    
      action_panel(game: @game)
      tableau(game: @game) {
        layout_data {
          width TABLEAU_WIDTH
          height TABLEAU_HEIGHT
        }
      }
      
      menu_bar {
        menu {
          text '&Game'
          menu_item {
            text '&Restart'
            accelerator (OS.mac? ? :command : :ctrl), :r
            
            on_widget_selected {
              @game.restart!
            }
          }
          menu_item {
            text 'E&xit'
            accelerator :alt, :f4
            
            on_widget_selected {
              body_root.close
            }
          }
        }
        menu {
          text '&Help'
          menu_item {
            text '&About...'
            on_widget_selected {
              display_about_dialog
            }
          }
        }
      }
    }
  }

  def display_about_dialog
    message_box(body_root) {
      text 'About'
      message "Glimmer Klondike Solitaire\nGlimmer DSL for SWT Elaborate Sample"
    }.open
  end
end

KlondikeSolitaire.launch
