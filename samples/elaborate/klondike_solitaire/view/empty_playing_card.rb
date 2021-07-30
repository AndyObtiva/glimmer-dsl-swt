class KlondikeSolitaire
  module View
    class EmptyPlayingCard
      include Glimmer::UI::CustomShape
      
      option :suit
  
      body {
        rectangle(0, 0, 49, 79, 15, 15) {
          foreground :gray
          
          if suit
            text {
              string suit.to_s[0].upcase
              x :default
              y :default
              is_transparent true
            }
          end
        }
      }
  
    end
  end
end
