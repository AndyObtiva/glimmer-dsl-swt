require_relative 'playing_card'
require_relative 'dealt_pile'
require_relative 'dealing_pile'
require_relative 'column_pile'
require_relative 'foundation_pile'

class KlondikeSolitaire
  module Model
    class Game
      COLUMN_PILE_COUNT = 7
        
      attr_reader :deck, :dealing_pile, :dealt_pile, :column_piles, :foundation_piles
      
      def initialize
        @deck = new_deck
        @dealt_pile = DealtPile.new(self)
        @dealing_pile = DealingPile.new(self)
        @column_piles = COLUMN_PILE_COUNT.times.map {|n| ColumnPile.new(self, n + 1)}
        @foundation_piles = PlayingCard::SUITS.map {|suit| FoundationPile.new(self, suit)}
      end
                  
      def restart!
        @deck = new_deck
        @dealt_pile.reset!
        @dealing_pile.reset!
        @column_piles.each(&:reset!)
        @foundation_piles.each(&:reset!)
      end
        
      private
      
      def new_deck
        PlayingCard.deck.shuffle
      end
    end
  end
end
