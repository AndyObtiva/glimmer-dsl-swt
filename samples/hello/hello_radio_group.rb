# Copyright (c) 2007-2020 Andy Maleh
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

class Person
  attr_accessor :gender, :age_group
  
  def initialize
    reset
  end
  
  def gender_options
    ['Male', 'Female']
  end
  
  def age_group_options
    ['Child', 'Teen', 'Adult', 'Senior']  
  end
  
  def reset
    self.gender = nil
    self.age_group = 'Adult'
  end
end

class HelloRadioGroup
  include Glimmer
  
  def launch
    person = Person.new
    
    shell {
      text 'Hello, Radio Group!'      
      row_layout :vertical           
      
      label {
        text 'Gender:'
        font style: :bold
      }
      
      radio_group {
        row_layout :horizontal
        selection bind(person, :gender)
      }
            
      label {
        text 'Age Group:'
        font style: :bold
      }
      
      radio_group {
        row_layout :horizontal
        selection bind(person, :age_group)
      }
      
      button {
        text 'Reset'
        
        on_widget_selected do
          person.reset
        end
      }
    }.open
  end
end

HelloRadioGroup.new.launch
