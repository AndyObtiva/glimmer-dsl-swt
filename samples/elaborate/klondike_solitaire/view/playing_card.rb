class KlondikeSolitaire
  module View
    class PlayingCard
      include Glimmer::UI::CustomShape
  
      options :card_x, :card_y, :model, :parent_pile
      
      before_body do
        self.card_x ||= 0
        self.card_y ||= 0
      end
  
      body {
        rectangle(card_x, card_y, 49, 79, 15, 15) {
          background model.hidden ? :red : :white
          
          # border
          rectangle(0, 0, 49, 79, 15, 15) {
            foreground :black
          }
          
          unless model.hidden?
            text {
              string model ? "#{model.rank_text}#{model.suit_text}" : ""
              x 5
              y 5
              foreground model ? model.color : :transparent
            }
          end
        }
      }
  
    end
  end
end
