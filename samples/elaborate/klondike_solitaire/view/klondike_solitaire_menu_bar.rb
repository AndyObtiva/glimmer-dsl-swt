class KlondikeSolitaire
  module View
    class KlondikeSolitaireMenuBar
      include Glimmer::UI::CustomWidget
      
      option :game
      
      before_body do
        @display = display {
          on_about do
            display_about_dialog
          end
          
          on_preferences do
            display_about_dialog
          end
        }
      end
  
      body {
        menu_bar {
          menu {
            text '&Game'
            
            menu_item {
              text '&Restart'
              accelerator (OS.mac? ? :command : :ctrl), :r
              
              on_widget_selected do
                game.restart!
              end
            }
            
            menu_item {
              text 'E&xit'
              accelerator :alt, :f4
              
              on_widget_selected do
                exit(0)
              end
            }
          }
          menu {
            text '&Help'
            
            menu_item {
              text '&About...'
              
              on_widget_selected do
                display_about_dialog
              end
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
