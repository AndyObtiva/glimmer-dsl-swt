require 'glimmer-dsl-swt'

require_relative 'klondike_solitaire/model/game'

require_relative 'klondike_solitaire/view/action_panel'
require_relative 'klondike_solitaire/view/tableau'

class KlondikeSolitaire
  include Glimmer::UI::CustomShell
  
  PLAYING_CARD_WIDTH = 50
  PLAYING_CARD_HEIGHT = 80
  PLAYING_CARD_SPACING = 5

  ## Add options like the following to configure CustomShell by outside consumers
  #
  # options :title, :background_color
  # option :width, default: 320
  # option :height, default: 240

  ## Use before_body block to pre-initialize variables to use in body
  #
  #
  before_body {
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
  }

  ## Use after_body block to setup observers for widgets in body
  #
  # after_body {
  #
  # }

  ## Add widget content inside custom shell body
  ## Top-most widget must be a shell or another custom shell
  #
  body {
    shell(:no_resize) {
      row_layout(:vertical) {
        fill true
        center true
      }
      minimum_size 400, 400
      text "Glimmer Klondike Solitaire"
      background :dark_green
    
      action_panel(game: @game)
      tableau(game: @game) {
        layout_data {
          width 380
          height 400
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
