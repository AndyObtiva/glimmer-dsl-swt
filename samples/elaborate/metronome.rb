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
    attr_reader :beat_count
    attr_accessor :beats, :bpm
    
    def initialize(beat_count)
      self.beat_count = beat_count
      @bpm = 120
    end
    
    def beat_count=(value)
      @beat_count = value
      reset_beats!
    end
    
    def reset_beats!
      @beats = beat_count.times.map {Beat.new}
      @beats.first.on!
    end
  end

  include Glimmer::UI::CustomShell
      
  attr_accessor :rhythm
  
  before_body {
    @rhythm = Rhythm.new(4)
  }
  
  body {
    shell {
      row_layout(:vertical) {
        center true
      }
      text 'Glimmer Metronome'
      
      label {
        text 'Beat Count'
        font height: 30, style: :bold
      }
      
      spinner {
        minimum 1
        maximum 64
        selection bind(self, 'rhythm.beat_count', after_write: ->(v) {restart_metronome})
        font height: 30
      }
      
      label {
        text 'BPM'
        font height: 30, style: :bold
      }
      
      spinner {
        minimum 30
        maximum 1000
        selection bind(self, 'rhythm.bpm')
        font height: 30
      }
      
      @beat_container = beat_container
      
      on_swt_show {
        start_metronome
      }
      
      on_widget_disposed {
        stop_metronome
      }
    }
  }
  
  def beat_container
    composite {
      grid_layout(@rhythm.beat_count, true) {
        margin_left 10
      }
      
      @rhythm.beat_count.times { |n|
        canvas {
          rectangle(0, 0, 50, 50, 36, 36) {
            background bind(self, "rhythm.beats[#{n}].on") {|on| on ? :red : :yellow}
          }
        }
      }
    }
  end
  
  def start_metronome
    @thread ||= Thread.new {
      @rhythm.beat_count.times.cycle { |n|
        sleep(60.0/@rhythm.bpm.to_f)
        @rhythm.beats.each(&:off!)
        @rhythm.beats[n].on!
      }
    }
    if @beat_container.nil?
      body_root.content {
        @beat_container = beat_container
      }
      body_root.layout(true, true)
      body_root.pack(true)
    end
  end
  
  def stop_metronome
    @thread&.kill # safe since no stored data is involved
    @thread = nil
    @beat_container&.dispose
    @beat_container = nil
  end
  
  def restart_metronome
    stop_metronome
    start_metronome
  end
end

Metronome.launch
