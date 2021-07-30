require_relative '../model/dealing_pile'

require_relative 'empty_playing_card'
require_relative 'hidden_playing_card'

class KlondikeSolitaire
  module View
    class DealingPile
      include Glimmer::UI::CustomShape
      
      options :pile_x, :pile_y, :model
      
      after_body {
        observe(model, 'playing_cards.empty?') do |empty_value|
          body_root.shapes.to_a.each(&:dispose)
          if empty_value
            body_root.content {
              empty_playing_card
            }
          else
            body_root.content {
              hidden_playing_card
            }
          end
        end
      }
  
      body {
        shape(pile_x, pile_y) {
          hidden_playing_card
        }
      }
  
    end
  end
end
