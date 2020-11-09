class Person
  include Glimmer
  attr_accessor :age
  
  def age_classification
    return if age.nil?
    if age < 10
      'Child'
    elsif age.between?(10, 12)
      'Tween'
    elsif age.between?(13, 19)
      'Teen'
    elsif age.between?(20, 29)
      '20s Adult'
    elsif age.between?(30, 39)
      '30s Adult'
    elsif age.between?(40, 49)
      '40s Adult'
    elsif age.between?(50, 59)
      '50s Adult'
    else
      'Senior Adult'
    end
  end
end

person = Person.new
person.age = 7

shell {
  grid_layout
  
  text 'Hello, Spinner!'
  
  label {
    text 'Type or spin an age to see its classification'
  }
  
  label {
    text 'Age:'
    font style: :bold
  }
  
  spinner(:right) {
    selection bind(person, :age)
    minimum 0
    maximum 150
  }
  
  label {
    text 'Classification:'
    font style: :bold
  }
  
  label {
    layout_data :fill, :center, true, false
    text bind(person, :age_classification, computed_by: :age)
  }
}.open
