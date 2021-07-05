require 'glimmer-dsl-swt'

class HelloText
  include Glimmer::UI::CustomShell
  
  attr_accessor :default, :center, :left, :right, :password, :telephone, :read_only, :wrap, :multi
  
  before_body {
    self.default = 'default is :border style'
    self.center = 'centered'
    self.left = 'left-aligned'
    self.right = 'right-aligned'
    self.password = 'password'
    self.telephone = '555-555-5555'
    self.read_only = 'Telephone area code is 555'
    self.wrap = 'wraps if text content is too long like this example'
    self.multi = "multi-line enables hitting enter,\nbut does not wrap by default"
  }
  
  body {
    shell {
      grid_layout 2, false
      
      text 'Hello, Text!'
      minimum_size 350, 100
      
      label {
        text 'text'
      }
      text { # includes :border style by default
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
        text 'text(:left, :border)'
      }
      text(:left, :border) {
        layout_data :fill, :center, true, false
        text <=> [self, :left]
      }
      
      label {
        text 'text(:right, :border)'
      }
      text(:right, :border) {
        layout_data :fill, :center, true, false
        text <=> [self, :right]
      }
      
      label {
        text 'text(:password, :border)'
      }
      text(:password, :border) {
        layout_data :fill, :center, true, false
        text <=> [self, :password]
      }
      
      label {
        text 'text(:read_only, :border)'
      }
      text(:read_only, :border) {
        layout_data :fill, :center, true, false
        text <=> [self, :read_only]
      }
      
      label {
        text 'text with event handlers'
      }
      text {
        layout_data :fill, :center, true, false
        text <=> [self, :telephone]
        
        # this event kicks just after the user typed and before modifying the text attribute value
        on_verify_text do |verify_event|
          new_text = verify_event.widget.text.clone
          new_text[verify_event.start...verify_event.end] = verify_event.text
          verify_event.doit = telephone?(new_text)
        end
        
        # this event kicks just after the text widget has been verified and modified
        on_modify_text do |modify_event|
          self.read_only = "Telephone area code is #{modify_event.widget.text.gsub(/[^0-9]/, '')[0...3]}"
        end
      }
      
      label {
        text 'text(:wrap, :border)'
      }
      text(:wrap, :border) {
        layout_data(:fill, :center, true, false) {
          width_hint 100
        }
        text <=> [self, :wrap]
      }
      
      label {
        text 'text(:multi, :border)'
      }
      text(:multi, :border) {
        layout_data :fill, :center, true, false
        text <=> [self, :multi]
      }
    }
  }
  
  def telephone?(text)
    !!text.match(/^\d{0,3}[-.\/]?\d{0,3}[-.\/]?\d{0,4}$/)
  end
end

HelloText.launch
