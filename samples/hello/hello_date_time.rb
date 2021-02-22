# Copyright (c) 2007-2021 Andy Maleh
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

class HelloDateTime
  class Person
    attr_accessor :date_of_birth
  end
  
  include Glimmer::UI::CustomShell
  
  before_body {
    @person = Person.new
    @person.date_of_birth = DateTime.new(2013, 7, 12, 18, 37, 23)
  }
  
  body {
    shell {
      row_layout :vertical
      
      text 'Hello, Date Time!'
      minimum_size 180, 180
      
      label {
        text 'Date of Birth'
        font height: 16, style: :bold
      }
      
      date { # alias for date_time(:date)
        date_time bind(@person, :date_of_birth)
      }
      
      date_drop_down { # alias for date_time(:date, :drop_down)
        date_time bind(@person, :date_of_birth)
      }
      
      time { # alias for date_time(:time)
        date_time bind(@person, :date_of_birth)
      }
      
      calendar { # alias for date_time(:calendar)
        date_time bind(@person, :date_of_birth)
      }
    }
  }
end

HelloDateTime.launch
