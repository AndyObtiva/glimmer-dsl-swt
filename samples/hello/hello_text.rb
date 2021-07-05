require 'glimmer-dsl-swt'

class HelloText
  include Glimmer::UI::CustomShell
  
  attr_accessor :default, :center, :password, :telephone
  
  before_body {
    self.default = 'default'
    self.center = 'centered'
    self.password = 'password'
    self.telephone = '555-555-5555'
  }
  
  body {
    shell {
      grid_layout 2, false
      
      text 'Hello, Text!'
      minimum_size 350, 100
      
      label {
        text 'text'
      }
      text {
        layout_data :fill, :center, true, false
        text <=> [self, :default]
      }
      
      label {
        text 'text(:center, :border)'
      }
      text(:center, :border) {
        layout_data :fill, :center, true, false
        text <=> [self, :center]
      }
      
      label {
        text 'text(:password, :border)'
      }
      text(:password, :border) {
        layout_data :fill, :center, true, false
        text <=> [self, :password]
      }
      
      label {
        text 'text with on_verify_text'
      }
      text {
        layout_data :fill, :center, true, false
        text <=> [self, :telephone]
        
        on_verify_text do |verify_event|
          new_text = verify_event.widget.text.clone
          new_text[verify_event.start...verify_event.end] = verify_event.text
          verify_event.doit = telephone?(new_text)
        end
      }
    }
  }
  
  def telephone?(text)
    !!text.match(/^\d{0,3}[-.\/]?\d{0,3}[-.\/]?\d{0,4}$/)
  end
end

HelloText.launch
