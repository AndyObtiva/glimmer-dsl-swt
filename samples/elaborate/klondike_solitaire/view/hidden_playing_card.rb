class KlondikeSolitaire
  module View
    class HiddenPlayingCard
      include Glimmer::UI::CustomShape
  
      body {
        rectangle(0, 0, 49, 79, 15, 15) {
          background :red
          
          # border
          rectangle(0, 0, 49, 79, 15, 15) {
            foreground :black
          }
        }
      }
  
    end
  end
end
