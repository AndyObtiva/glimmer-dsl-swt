class Person
  attr_accessor :country, :country_options

  def initialize
    self.country_options=["", "Canada", "US", "Mexico"]
    self.country = "Canada"
  end

  def reset_country
    self.country = "Canada"
  end
end

class HelloCombo
  include Glimmer
  def launch
    person = Person.new
    
    shell {
      fill_layout :vertical
      text 'Hello, Combo!'
      
      combo(:read_only) {
        selection bind(person, :country)
      }
      
      button {
        text "Reset Selection"
        
        on_widget_selected do
          person.reset_country
        end
      }
    }.open
  end
end

HelloCombo.new.launch
