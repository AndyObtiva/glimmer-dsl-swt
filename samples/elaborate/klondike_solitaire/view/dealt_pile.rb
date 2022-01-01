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
            body_root.content {
              playing_card(model: model.playing_cards.last, parent_pile: self) {
                drag_source true
              }
            }
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
