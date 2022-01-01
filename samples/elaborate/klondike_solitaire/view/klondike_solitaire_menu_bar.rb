class KlondikeSolitaire
  module View
    class KlondikeSolitaireMenuBar
      include Glimmer::UI::CustomWidget
      
      option :game
      
      before_body do
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
        menu_bar {
          menu {
            text '&Game'
            menu_item {
              text '&Restart'
              accelerator (OS.mac? ? :command : :ctrl), :r
              
              on_widget_selected {
                game.restart!
              }
            }
            menu_item {
              text 'E&xit'
              accelerator :alt, :f4
              
              on_widget_selected {
                exit(0)
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
      
      def display_about_dialog
        message_box(body_root) {
          text 'About'
          message "Glimmer Klondike Solitaire\nGlimmer DSL for SWT Elaborate Sample"
        }.open
      end
    end
  end
end
