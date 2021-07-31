require_relative '../model/playing_card'

class KlondikeSolitaire
  module View
    class EmptyPlayingCard
      include Glimmer::UI::CustomShape
      
      option :suit
  
      body {
        rectangle(0, 0, 49, 79, 15, 15) {
          foreground :gray
          
          if suit
            text {
              string Model::PlayingCard.suit_text(suit)
              x :default
              y :default
              is_transparent true
              foreground Model::PlayingCard::BLACK_SUITS.include?(suit) ? :black : :red
            }
          end
        }
      }
  
    end
  end
end
