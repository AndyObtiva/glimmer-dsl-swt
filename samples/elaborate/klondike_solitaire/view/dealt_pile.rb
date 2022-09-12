require_relative '../model/dealt_pile'

require_relative 'empty_playing_card'
require_relative 'playing_card'

class KlondikeSolitaire
  module View
    class DealtPile
      include Glimmer::UI::CustomShape
      
      options :pile_x, :pile_y, :model
      
      after_body do
        observe(model, 'playing_cards.empty?') do |empty_value|
          if empty_value
            body_root.shapes.to_a.dup.each { |shape| shape.dispose(redraw: false) }
            body_root.content {
              empty_playing_card
            }
          else
            before_last_shape = body_root.shapes[-2] && body_root.shapes[-2].get_data('custom_shape').respond_to?(:model) && body_root.shapes[-2].get_data('custom_shape').model
            if model.playing_cards.last == before_last_shape # happens when dragging card out
              body_root.shapes.last.dispose
            else
              body_root.content {
                playing_card(model: model.playing_cards.last, parent_pile: self) {
                  drag_source true
                }
              }
            end
          end
        end
      end
  
      body {
        shape(pile_x, pile_y) {
          empty_playing_card
        }
      }
                                
    end
  end
end
