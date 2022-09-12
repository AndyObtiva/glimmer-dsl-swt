class KlondikeSolitaire
  module Model
    class DealingPile
      DEALING_INITIAL_COUNT = 24
      
      def initialize(game)
        @game = game
        reset!
      end
      
      def reset!
        playing_cards.clear
        DEALING_INITIAL_COUNT.times { playing_cards << @game.deck.pop }
      end

      def deal!
        playing_card = playing_cards.shift
        if playing_card.nil?
          @game.dealt_pile.playing_cards.each do |a_playing_card|
            playing_cards << a_playing_card
          end
          @game.dealt_pile.playing_cards.clear
        else
          @game.dealt_pile.push!(playing_card)
        end
      end
      
      def playing_cards
        @playing_cards ||= []
      end
    end
  end
end
