class KlondikeSolitaire
  module Model
    class FoundationPile
      attr_reader :suit
    
      def initialize(game, suit)
        @game = game
        @suit = suit
        reset!
      end
      
      def reset!
        playing_cards.clear
      end
    
      # adds a card
      # validates if it is a card that belongs to the suit
      def add!(playing_card)
        if playing_card.suit == suit &&
          (
            (playing_cards.empty? && playing_card.rank == 1) ||
            playing_card.rank == (playing_cards.last.rank + 1)
          )
          playing_cards.push(playing_card)
        else
          raise "Cannot add #{playing_card} to #{self}"
        end
      end
      
      def playing_cards
        @playing_cards ||= []
      end
            
      def to_s
        "Foundation Pile #{suit} (#{playing_cards.map {|card| "#{card.rank}#{card.suit.to_s[0].upcase}"}.join(" | ")})"
      end
      
    end
  end
end
