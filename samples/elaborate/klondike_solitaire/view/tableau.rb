require_relative 'dealing_pile'
require_relative 'dealt_pile'
require_relative 'column_pile'
require_relative 'foundation_pile'

require_relative '../model/game'

class KlondikeSolitaire
  module View
    class Tableau
      include Glimmer::UI::CustomWidget
      
      option :game
      
      body {
        canvas {
          background :dark_green
          
          # row 1
          @foundation_piles = Model::PlayingCard::SUITS.each_with_index.map do |suit, i|
            foundation_pile(pile_x: MARGIN + i*(PLAYING_CARD_WIDTH + PLAYING_CARD_SPACING), pile_y: 0, game: game, suit: suit)
          end
          @dealt_pile = dealt_pile(pile_x: MARGIN + 5*(PLAYING_CARD_WIDTH + PLAYING_CARD_SPACING), pile_y: 0, model: game.dealt_pile)
          @dealing_pile = dealing_pile(pile_x: MARGIN + 6*(PLAYING_CARD_WIDTH + PLAYING_CARD_SPACING), pile_y: 0, model: game.dealing_pile)
          
          # row 2
          @column_piles = 7.times.map do |n|
            column_pile(pile_x: MARGIN + n*(PLAYING_CARD_WIDTH + PLAYING_CARD_SPACING), pile_y: PLAYING_CARD_HEIGHT + PLAYING_CARD_SPACING, model: game.column_piles[n])
          end
          
          on_mouse_up do |event|
            if @dealing_pile.body_root.include?(event.x, event.y)
              game.dealing_pile.deal!
            end
          end
        }
      }
  
    end
  end
end
