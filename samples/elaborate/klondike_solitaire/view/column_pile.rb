require_relative '../model/column_pile'

require_relative 'playing_card'

class KlondikeSolitaire
  module View
    class ColumnPile
      include Glimmer::UI::CustomShape
  
      options :pile_x, :pile_y, :model
      
      after_body {
        observe(model, 'playing_cards.last.hidden') do
          build_column_pile(model.playing_cards)
        end
        build_column_pile(model.playing_cards)
      }
      
      body {
        shape(pile_x, pile_y) {
          on_drop do |drop_event|
            begin
              card_shape = drop_event.dragged_shape.get_data('custom_shape')
              card = card_shape.model
              model.add!(card)
              card_parent_pile = card_shape.parent_pile
              card_source_model = card_parent_pile.model
              cards = card_source_model.remove!(card)
              cards[1..-1].each { |card| model.add!(card) } if cards.is_a?(Array) # if it is a column pile
            rescue => e
              Glimmer::Config.logger.debug { "Error encountered on drop of a card to a column pile: #{e.full_message}" }
              drop_event.doit = false
            end
          end
        }
      }
  
      def build_column_pile(playing_cards)
        body_root.shapes.to_a.dup.each { |shape| shape.dispose(redraw: false) }
        current_parent = body_root
        playing_cards.each_with_index do |card, i|
          current_parent.content {
            current_parent = playing_card(card_x: 0, card_y: 20, model: card, parent_pile: self) {
              drag_source true unless card.hidden?
            }.body_root
          }
        end
      end
    end
  end
end
