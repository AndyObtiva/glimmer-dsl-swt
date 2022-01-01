require_relative '../model/playing_card'

class KlondikeSolitaire
  module View
    class EmptyPlayingCard
      include Glimmer::UI::CustomShape
      
      options :card_x, :card_y, :suit
      
      before_body do
        self.card_x ||= 0
        self.card_y ||= 0
      end
      
      body {
        rectangle(card_x, card_y, PLAYING_CARD_WIDTH - 1, PLAYING_CARD_HEIGHT - 1, 15, 15) {
          foreground :gray
          
          if suit
            text {
              string Model::PlayingCard.suit_text(suit)
              font height: 20
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
