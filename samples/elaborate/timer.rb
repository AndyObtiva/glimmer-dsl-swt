require 'glimmer-dsl-swt'
require 'os'

class Timer
  include Glimmer::UI::CustomShell
  
  import 'javax.sound.sampled'

  FILE_SOUND_ALARM = File.expand_path(File.join('timer', 'alarm1.wav'), __dir__)
  COMMAND_KEY = OS.mac? ? :command : :ctrl
      
  ## Add options like the following to configure CustomShell by outside consumers
  #
  # options :title, :background_color
  # option :width, default: 320
  # option :height, default: 240

  attr_accessor :countdown, :min, :sec

  ## Use before_body block to pre-initialize variables to use in body
  #
  #
  before_body {
    Display.setAppName('Glimmer Timer')
    
    @display = display {
      on_about {
        display_about_dialog
      }
      on_preferences {
        display_about_dialog
      }
    }

    @min = 0
    @sec = 0
  }

  ## Use after_body block to setup observers for widgets in body
  #
  after_body {
    Thread.new {
      loop {
        sleep(1)
        if @countdown
          sync_exec {
            @countdown_time = Time.new(1, 1, 1, 0, min, sec)
            @countdown_time -= 1
            self.min = @countdown_time.min
            self.sec = @countdown_time.sec
            if @countdown_time.min <= 0 && @countdown_time.sec <= 0
              stop_countdown
              play_countdown_done_sound
            end
          }
        end
      }
    }
  }

  ## Add widget content inside custom shell body
  ## Top-most widget must be a shell or another custom shell
  #
  body {
    shell {
      grid_layout # 1 column
      
      # Replace example content below with custom shell content
      minimum_size (OS.windows? ? 214 : 200), 114
      image File.join(APP_ROOT, 'package', 'windows', "Timer.ico") if OS.windows?
      text "Glimmer Timer"

      timer_menu_bar
      
      countdown_group
    }
  }
  
  def timer_menu_bar
    menu_bar {
      menu {
        text '&Action'
        
        menu_item {
          text '&Start'
          accelerator COMMAND_KEY, 's'
          enabled <= [self, :countdown, on_read: :!]
          
          on_widget_selected {
            start_countdown
          }
        }
        menu_item {
          text 'St&op'
          enabled <= [self, :countdown]
          accelerator COMMAND_KEY, 'o'
          
          on_widget_selected {
            stop_countdown
          }
        }
        unless OS.mac?
          menu_item(:separator)
          menu_item {
            text 'E&xit'
            accelerator :alt, :f4
            
            on_widget_selected {
              exit(0)
            }
          }
        end
      }
      menu {
        text '&Help'
                    
        menu_item {
          text '&About'
          accelerator COMMAND_KEY, :shift, 'a'
          
          on_widget_selected {
            display_about_dialog
          }
        }
      }
    }
  end
  
  def countdown_group
    group {
      # has grid layout with 1 column by default
      text 'Countdown'
      font height: 20

      countdown_group_field_composite
      
      countdown_group_button_composite
    }
  end
  
  def countdown_group_field_composite
    composite {
      row_layout {
        margin_width 0
        margin_height 0
      }
      @min_spinner = spinner {
        text_limit 2
        digits 0
        maximum 59
        selection <=> [self, :min]
        enabled <= [self, :countdown, on_read: :!]
        on_widget_default_selected {
          start_countdown
        }
      }
      label {
        text ':'
        font(height: 18) if OS.mac?
      }
      @sec_spinner = spinner {
        text_limit 2
        digits 0
        maximum 59
        selection <=> [self, :sec]
        enabled <= [self, :countdown, on_read: :!]
        on_widget_default_selected {
          start_countdown
        }
      }
    }
  end
  
  def countdown_group_button_composite
    composite {
      row_layout {
        margin_width 0
        margin_height 0
      }
      @start_button = button {
        text '&Start'
        enabled <= [self, :countdown, on_read: :!]
        on_widget_selected {
          start_countdown
        }
        on_key_pressed { |event|
          start_countdown if event.keyCode == swt(:cr)
        }
      }
      @stop_button = button {
        text 'St&op'
        enabled <= [self, :countdown]
        on_widget_selected {
          stop_countdown
        }
        on_key_pressed { |event|
          stop_countdown if event.keyCode == swt(:cr)
        }
      }
    }
  end

  def display_about_dialog
    message_box(body_root) {
      text 'About'
      message "Glimmer Timer\n\nCopyright (c) 2007-2021 Andy Maleh"
    }.open
  end
  
  def start_countdown
    self.countdown = true
    @stop_button.swt_widget.set_focus
  end

  def stop_countdown
    self.countdown = false
    @min_spinner.swt_widget.set_focus
  end

  def play_countdown_done_sound
    begin
      file_or_stream = java.io.File.new(FILE_SOUND_ALARM)
      audio_stream = AudioSystem.get_audio_input_stream(file_or_stream)
      clip = AudioSystem.clip
      clip.open(audio_stream)
      clip.start
    rescue => e
      Glimmer::Config.logger.error e.full_message
    end
  end
end

Timer.launch
