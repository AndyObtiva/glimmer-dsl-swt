require_relative '../model/playing_card'
require_relative '../model/foundation_pile'

class KlondikeSolitaire
  module View
    class FoundationPile
      include Glimmer::UI::CustomShape
      
      options :pile_x, :pile_y, :game, :suit
      
      attr_accessor :model
      
      before_body do
        self.model = game.foundation_piles[Model::PlayingCard::SUITS.index(suit)]
      end
  
      after_body do
        observe(model, 'playing_cards.last') do |last_card|
          if last_card
            body_root.content {
              playing_card(model: last_card)
            }
          else
            body_root.clear_shapes
            body_root.content {
              empty_playing_card(suit: suit)
            }
          end
        end
      end
      
      body {
        shape(pile_x, pile_y) {
          empty_playing_card(suit: suit)
          
          on_drop do |drop_event|
            begin
              card_shape = drop_event.dragged_shape.get_data('custom_shape')
              card = card_shape.model
              card_parent_pile = card_shape.parent_pile
              card_source_model = card_parent_pile.model
              raise 'Cannot accept multiple cards' if card_source_model.playing_cards.index(card) != (card_source_model.playing_cards.size - 1)
              drop_event.dragged_shape.dispose(redraw: false)
              model.add!(card)
              card_source_model.remove!(card)
            rescue => e
              Glimmer::Config.logger.debug { "Error encountered on drop of a card to a foundation pile: #{e.full_message}" }
              drop_event.doit = false
            end
          end
        }
      }
    end
    
  end
  
end
