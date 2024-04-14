# Copyright (c) 2007-2024 Andy Maleh
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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
  
  import 'javax.sound.sampled'
  
  GEM_ROOT = File.expand_path(File.join('..', '..'), __dir__)
  FILE_SOUND_METRONOME_UP = File.join(GEM_ROOT, 'sounds', 'metronome-up.wav')
  FILE_SOUND_METRONOME_DOWN = File.join(GEM_ROOT, 'sounds', 'metronome-down.wav')
      
  attr_accessor :rhythm
  
  before_body do
    @rhythm = Rhythm.new(4)
  end
  
  body {
    shell(:no_resize) {
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
        selection <=> [self, 'rhythm.beat_count', after_write: ->(v) {restart_metronome}]
        font height: 30
      }
      
      label {
        text 'BPM'
        font height: 30, style: :bold
      }
      
      spinner {
        minimum 30
        maximum 1000
        selection <=> [self, 'rhythm.bpm']
        font height: 30
      }
      
      @beat_container = beat_container
      
      on_swt_show do
        start_metronome
      end
      
      on_widget_disposed do
        stop_metronome
      end
    }
  }
  
  def beat_container
    composite {
      grid_layout(@rhythm.beat_count, true)
      
      @rhythm.beat_count.times { |n|
        canvas {
          layout_data {
            width_hint 50
            height_hint 50
          }
          rectangle(0, 0, :default, :default, 36, 36) {
            background <= [self, "rhythm.beats[#{n}].on", on_read: ->(on) { on ? :red : :yellow}]
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
        sound_file = n == 0 ? FILE_SOUND_METRONOME_UP : FILE_SOUND_METRONOME_DOWN
        play_sound(sound_file)
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
  
  # Play sound with the Java Sound library
  def play_sound(sound_file)
    begin
      file_or_stream = java.io.File.new(sound_file)
      audio_stream = AudioSystem.get_audio_input_stream(file_or_stream)
      clip = AudioSystem.clip
      clip.open(audio_stream)
      clip.start
    rescue => e
      puts e.full_message
    end
  end
end

Metronome.launch
