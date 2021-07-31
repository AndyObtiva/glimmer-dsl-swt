class KlondikeSolitaire
  module Model
    class PlayingCard
      SUITS = [:spades, :hearts, :clubs, :diamonds]
      BLACK_SUITS = [:spades, :clubs]
      RED_SUITS = [:hearts, :diamonds]
      RANK_COUNT = 13
      
      class << self
        def deck
          suit_decks.flatten
        end
        
        def suit_decks
          SUITS.map do |suit|
            suit_deck(suit)
          end
        end
        
        def suit_deck(suit)
          1.upto(RANK_COUNT).map do |rank|
            new(rank, suit)
          end
        end
        
        def rank_text(rank)
          case rank
          when 1
            'A'
          when 11
            'J'
          when 12
            'Q'
          when 13
            'K'
          else
            rank
          end
        end
        
        def suit_text(suit)
          case suit
          when :spades
            "♠"
          when :hearts
            "♥"
          when :clubs
            "♣"
          when :diamonds
            "♦"
          end
        end
      end
      
      attr_reader :rank, :suit
      attr_accessor :hidden
      alias hidden? hidden
      
      def initialize(rank, suit, hidden = false)
        @rank = rank
        @suit = suit
        @hidden = hidden
      end
      
      def color
        if BLACK_SUITS.include?(suit)
          :black
        elsif RED_SUITS.include?(suit)
          :red
        end
      end
      
      def to_s
        "Playing Card #{rank}#{suit.to_s[0].upcase}"
      end
      
      def suit_text
        self.class.suit_text(suit)
      end
      
      def rank_text
        self.class.rank_text(rank)
      end
    end
  end
end
