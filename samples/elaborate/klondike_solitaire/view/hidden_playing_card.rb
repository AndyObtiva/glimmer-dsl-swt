class KlondikeSolitaire
  module View
    class HiddenPlayingCard
      include Glimmer::UI::CustomShape
  
      options :card_x, :card_y
      
      before_body do
        self.card_x ||= 0
        self.card_y ||= 0
      end
      
      body {
        rectangle(card_x, card_y, PLAYING_CARD_WIDTH - 1, PLAYING_CARD_HEIGHT - 1, 15, 15) {
          background :red
          
          # border
          rectangle(0, 0, PLAYING_CARD_WIDTH - 1, PLAYING_CARD_HEIGHT - 1, 15, 15) {
            foreground :black
          }
        }
      }
  
    end
  end
end
