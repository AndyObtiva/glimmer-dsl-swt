class KlondikeSolitaire
  module Model
    class DealtPile
      def initialize(game)
        @game = game
      end
      
      def reset!
        playing_cards.clear
      end
    
      def push!(playing_card)
        playing_cards.push(playing_card)
      end
      
      def remove!(card)
        playing_cards.delete(card)
      end
      
      def playing_cards
        @playing_cards ||= []
      end
    end
  end
end
