require 'glimmer-dsl-swt'

class Metronome
  class Beat
    attr_accessor :on
    
    def off!
      self.on = false
    end
    
    def on!
      self.on = true
    end
  end
  
  class Rhythm
    attr_accessor :beats, :signature_top, :signature_bottom
    
    def initialize(signature_top, signature_bottom)
      @signature_top = signature_top
      @signature_bottom = signature_bottom
      @beats = @signature_top.times.map {Beat.new}
    end
  end

  include Glimmer::UI::CustomShell
      
  attr_reader :beats
  
  before_body {
    @rhythm = Rhythm.new(4, 4)
    @beats = @rhythm.beats
  }
  
  body {
    shell {
      grid_layout 4, true
      text 'Glimmer Metronome'
      minimum_size 200, 200
            
      4.times { |n|
        canvas {
          layout_data {
            width_hint 50
            height_hint 50
          }
          oval(0, 0, 50, 50) {
            background bind(self, "beats[#{n}].on") {|on| on ? :red : :yellow}
          }
        }
      }
      
      on_swt_show {
        @thread ||= Thread.new {
          4.times.cycle { |n|
            sleep(0.25)
            beats.each(&:off!)
            beats[n].on!
          }
        }
      }
      
      on_widget_disposed {
        @thread.kill # safe since no stored data is involved
      }
    }
  }
end

Metronome.launch
