# Copyright (c) 2007-2021 Andy Maleh
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

require 'net/http'
require 'json'
require 'facets/string/titlecase'
require 'glimmer-dsl-swt'

class Weather
  include Glimmer::UI::CustomShell
  
  DEFAULT_FONT_HEIGHT = 40
  DEFAULT_FOREGROUND = :white
  
  attr_accessor :temp, :temp_min, :temp_max, :feels_like, :humidity
  
  before_body {
    fetch_weather!
  }
  
  after_body {
    Thread.new do
      loop do
        sleep(10)
        break if body_root.disposed?
        fetch_weather!
      end
    end
  }
  
  body {
    shell(:no_resize) {
      grid_layout
            
      text 'Glimmer Weather'
      minimum_size 400, 300
      background rgb(140, 170, 200)
      
      composite {
        grid_layout 2, false

        layout_data(:center, :center, true, true)
        
        background :transparent
        
        rectangle(0, 0, [:default, -1], [:default, -2], 15, 15) {
          foreground DEFAULT_FOREGROUND
        }
  
        %w[temp temp_min temp_max feels_like humidity].each do |field_name|
          field(field_name)
        end
      }
    }
  }
  
  def field(field_name)
    label {
      layout_data :fill, :center, false, false
      text field_name.titlecase
      font height: DEFAULT_FONT_HEIGHT
      foreground DEFAULT_FOREGROUND
    }
    label {
      layout_data(:fill, :center, true, false)
      text <= [self, field_name, on_read: ->(t) { t.to_f.round }]
      font height: DEFAULT_FONT_HEIGHT
      foreground DEFAULT_FOREGROUND
    }
  end
  
  def fetch_weather!
    self.weather_data = JSON.parse(Net::HTTP.get('api.openweathermap.org', '/data/2.5/weather?q=montreal,qc,ca&appid=1d16d70a9aec3570b5cbd27e6b421330'))
  rescue
    # No Op
  end
  
  def weather_data=(data)
    @weather_data = data
    main_data = data['main']
    self.temp = kelvin_to_celcius(main_data['temp'])
    self.temp_min = kelvin_to_celcius(main_data['temp_min'])
    self.temp_max = kelvin_to_celcius(main_data['temp_max'])
    self.feels_like = kelvin_to_celcius(main_data['feels_like'])
    self.humidity = main_data['humidity']
  end
  
  def kelvin_to_celcius(kelvin)
    kelvin - 273.15
  end
end

Weather.launch
