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

class HelloSpinner
  class Person
    attr_accessor :donation
  end
  
  include Glimmer::UI::CustomShell
  
  before_body do
    @person = Person.new
    @person.donation = 500 # in cents
  end
  
  body {
    shell {
      grid_layout
      
      text 'Hello, Spinner!'
      
      label {
        text 'Please select the amount you would like to donate to the poor:'
      }
      
      composite {
        grid_layout 3, false
        
        label {
          layout_data {
            width_hint 240
          }
          text 'Amount:'
          font style: :bold
        }
        
        label {
          text '$'
        }
        
        spinner {
          digits 2 # digits after the decimal point
          minimum 100 # minimum value (including digits after the decimal point)
          maximum 15000 # maximum value (including digits after the decimal point)
          increment 500 # increment on up and down (including digits after the decimal point)
          page_increment 5000 # page increment on page up and page down (including digits after the decimal point)
          selection <=> [@person, :donation] # selection must be set last if other properties are configured to ensure value is within bounds
        }
        
        label {
          layout_data(:fill, :center, true, false)
          text <=> [@person, :donation, on_read: ->(value) { "Thank you for your donation of $#{"%.2f" % (value.to_f / 100.0)}"}]
        }

      }
    }
  }
end

HelloSpinner.launch
