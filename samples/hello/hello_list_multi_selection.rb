class Person
  attr_accessor :provinces, :provinces_options

  def initialize
    self.provinces_options=[
      "",
      "Quebec",
      "Ontario",
      "Manitoba",
      "Saskatchewan",
      "Alberta",
      "British Columbia",
      "Nova Skotia",
      "Newfoundland"
    ]
    self.provinces = ["Quebec", "Manitoba", "Alberta"]
  end

  def reset_provinces
    self.provinces = ["Quebec", "Manitoba", "Alberta"]
  end
end

class HelloListMultiSelection
  include Glimmer
  
  def launch
    person = Person.new
    
    shell {
      grid_layout      
      
      text 'Hello, List Multi Selection!'
      
      list(:multi) {
        selection bind(person, :provinces)
      }
      
      button {
        text "Reset Selection To Defaults"
        
        on_widget_selected { person.reset_provinces }
      }
    }.open
  end
end

HelloListMultiSelection.new.launch
