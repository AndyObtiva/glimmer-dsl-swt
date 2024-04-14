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

# This is a sample for the c_combo widget, a more customizable version of combo
class HelloCCombo
  class Person
    attr_accessor :country, :country_options
  
    def initialize
      self.country_options = ['', 'Canada', 'US', 'Mexico']
      reset_country!
    end
  
    def reset_country!
      self.country = 'Canada'
    end
  end

  include Glimmer::UI::CustomShell
  
  before_body do
    @person = Person.new
  end
  
  body {
    shell {
      row_layout(:vertical) {
        fill true
      }
      
      text 'Hello, C Combo!'
      
      c_combo(:read_only) {
        selection <=> [@person, :country] # also binds to country_options by convention
        font height: 45 # unlike `combo`, `c_combo` changes height when setting the font height
      }
      
      button {
        text 'Reset Selection'
        
        on_widget_selected do
          @person.reset_country!
        end
      }
    }
  }
end

HelloCCombo.launch
