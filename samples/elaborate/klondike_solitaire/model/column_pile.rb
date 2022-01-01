class KlondikeSolitaire
  module Model
    class ColumnPile
      include Glimmer::DataBinding::ObservableModel
      attr_reader :count
    
      def initialize(game, count)
        @game = game
        @count = count
        reset!
      end
      
      def reset!
        playing_cards.clear
        populate!(count.times.map { @game.deck.pop })
      end
    
      # this method does not validate
      def populate!(new_playing_cards)
        new_playing_cards.each_with_index do |playing_card, index|
          playing_card.hidden = true if index < (new_playing_cards.size - 1)
          playing_cards.push(playing_card)
        end
      end
      
      # this method validates that playing card fits at the bottom of the column (opposite color and one number smaller)
      # throws an error if it does not fit
      def add!(new_playing_card)
        bottom_card = playing_cards.last
        if (playing_cards.empty? && new_playing_card.rank == 13) ||
            (new_playing_card.color != bottom_card.color && new_playing_card.rank == (bottom_card.rank - 1))
          playing_cards.push(new_playing_card)
        else
          raise "Cannot add #{new_playing_card} to #{self}"
        end
      end
      
      def remove!(card)
        remove_cards_starting_at(playing_cards.index(card)).tap do |result|
          playing_cards.last&.hidden = false
        end
      end
      
      def remove_cards_starting_at(index)
        removed_cards = playing_cards[index...playing_cards.size]
        playing_cards[index...playing_cards.size] = []
        removed_cards
      end
      
      def playing_cards
        @playing_cards ||= []
      end
      
      def to_s
        "Column Pile #{count} (#{playing_cards.map {|card| "#{card.rank}#{card.suit.to_s[0].upcase}"}.join(" | ")})"
      end
    end
  end
end
