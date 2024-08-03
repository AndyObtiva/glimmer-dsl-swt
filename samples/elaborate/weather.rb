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
require 'net/http'
require 'json'
require 'facets/string/titlecase'
require 'base64'

class Weather
  include Glimmer::UI::CustomShell
  
  DEFAULT_FONT_HEIGHT = 30
  DEFAULT_FOREGROUND = :white
  DEFAULT_BACKGROUND = rgb(135, 176, 235)
  
  attr_accessor :postal_code, :temp
  
  before_body do
    @weather_mutex = Mutex.new
    self.postal_code = '60661'
    self.temp = '72'
  end
  
  after_body do
    Thread.new do
      loop do
        fetch_weather!
        sleep(10)
        break if body_root.disposed?
      end
    end
  end
  
  body {
    shell(:no_resize) {
      grid_layout
            
      text 'Glimmer Weather'
      minimum_size 400, (OS.linux? ? 330 : 300)
      background DEFAULT_BACKGROUND
      
      composite {
        layout_data(:center, :center, true, true)
        grid_layout 2, false
        background DEFAULT_BACKGROUND
        foreground DEFAULT_FOREGROUND

        label {
          layout_data(:center, :center, true, true)

          text "USA Zip Code:"
          background DEFAULT_BACKGROUND
          foreground DEFAULT_FOREGROUND
        }
        text {
          layout_data(:center, :center, true, true)
          
          text <=> [self, :postal_code]
          
          on_key_pressed do |event|
            if event.keyCode == swt(:cr) # carriage return
              Thread.new do
                fetch_weather!
              end
            end
          end
        }
      }
            
      tab_folder {
        layout_data(:center, :center, true, true) {
          width_hint OS.linux? ? 300 : 270
        }

        temp_unit = '℉'

        tab_item {
          grid_layout 2, false
          
          text temp_unit
          background DEFAULT_BACKGROUND
          
          rectangle(0, 0, [:default, -2], [:default, -2], 15, 15) {
            foreground DEFAULT_FOREGROUND
          }
    
          temp_field('temp', temp_unit)
        }
      }
    }
  }
  
  def temp_field(field_name, temp_unit)
    name_label(field_name)
    label {
      layout_data(:fill, :center, true, false)
      text <= [self, field_name, on_read: ->(t) { "#{t.to_f.round}°" }]
      font height: DEFAULT_FONT_HEIGHT
      background DEFAULT_BACKGROUND
      foreground DEFAULT_FOREGROUND
    }
  end
  
  def name_label(field_name)
    label {
      layout_data :fill, :center, false, false
      text "#{field_name.titlecase}:"
      font height: DEFAULT_FONT_HEIGHT
      background DEFAULT_BACKGROUND
      foreground DEFAULT_FOREGROUND
    }
  end
  
  def fetch_weather!
    return unless postal_code.length == 5 && postal_code.chars.all? {|c| c.match(/\d/) }
    @weather_mutex.synchronize do
      auth_token = Base64.encode64("self_maleh_andy:7CV7Oeb8pp")
      headers = {Authorization: "Basic #{auth_token}"}
      self.weather_data = JSON.parse(Net::HTTP.get(URI("https://api.meteomatics.com/now/t_2m:F/postal_US#{postal_code}/json"), headers))
    end
  rescue => e
    Glimmer::Config.logger.error "Unable to fetch weather due to error: #{e.full_message}"
  end
  
  def weather_data=(data)
    @weather_data = data
    self.temp = @weather_data['data'][0]['coordinates'][0]['dates'][0]['value']
  end
end

Weather.launch
