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

# This sample demonstrates the use of a `checkbox_group` (aka `check_group`) in Glimmer, which provides terser syntax
# than HelloCheckbox for representing multiple checkbox buttons (`button(:check)`) by relying on data-binding to
# automatically spawn the `checkbox` widgets (`button(:check)`) based on available options on the model.
class HelloCheckboxGroup
  class Person
    attr_accessor :activities
    
    def initialize
      reset_activities
    end
    
    def activities_options
      ['Skiing', 'Snowboarding', 'Snowmobiling', 'Snowshoeing']
    end
    
    def reset_activities
      self.activities = ['Snowboarding']
    end
  end
  
  include Glimmer::UI::CustomShell
  
  before_body do
    @person = Person.new
  end
  
  body {
    shell {
      text 'Hello, Checkbox Group!'
      row_layout :vertical
      
      label {
        text 'Check all snow activities you are interested in:'
        font style: :bold
      }
      
      checkbox_group {
        selection <=> [@person, :activities]
      }
    
      button {
        text 'Reset Activities'
        
        on_widget_selected do
          @person.reset_activities
        end
      }
    }
  }
end

HelloCheckboxGroup.launch
