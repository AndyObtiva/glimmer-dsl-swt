# Copyright (c) 2007-2022 Andy Maleh
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

class HelloRadio
  class Person
    attr_accessor :male, :female, :child, :teen, :adult, :senior
    
    def initialize
      reset!
    end
    
    def reset!
      self.male = nil
      self.female = nil
      self.child = nil
      self.teen = nil
      self.adult = true
      self.senior = nil
    end
  end
  
  include Glimmer::UI::CustomShell
  
  before_body do
    @person = Person.new
  end
  
  body {
    shell {
      text 'Hello, Radio!'
      row_layout :vertical
      
      label {
        text 'Gender:'
        font style: :bold
      }
      
      composite {
        row_layout
        
        radio {
          text 'Male'
          selection <=> [@person, :male]
        }
        
        radio {
          text 'Female'
          selection <=> [@person, :female]
        }
      }
      
      label {
        text 'Age Group:'
        font style: :bold
      }
      
      composite {
        row_layout
        
        radio {
          text 'Child'
          selection <=> [@person, :child]
        }
        
        radio {
          text 'Teen'
          selection <=> [@person, :teen]
        }
        
        radio {
          text 'Adult'
          selection <=> [@person, :adult]
        }
        
        radio {
          text 'Senior'
          selection <=> [@person, :senior]
        }
      }
      
      button {
        text 'Reset'
        
        on_widget_selected do
          @person.reset!
        end
      }
    }
  }
end

HelloRadio.launch
