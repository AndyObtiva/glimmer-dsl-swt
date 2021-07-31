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

require 'glimmer-dsl-swt'

class HelloComputed
  class Contact
    attr_accessor :first_name, :last_name, :year_of_birth
  
    def initialize(attribute_map)
      @first_name = attribute_map[:first_name]
      @last_name = attribute_map[:last_name]
      @year_of_birth = attribute_map[:year_of_birth]
    end
  
    def name
      "#{last_name}, #{first_name}"
    end
  
    def age
      Time.now.year - year_of_birth.to_i
    rescue
      0
    end
  end

  include Glimmer::UI::CustomShell

  before_body do
    @contact = Contact.new(
      first_name: 'Barry',
      last_name: 'McKibbin',
      year_of_birth: 1985
    )
  end

  body {
    shell {
      text 'Hello, Computed!'
      
      composite {
        grid_layout {
          num_columns 2
          make_columns_equal_width true
          horizontal_spacing 20
          vertical_spacing 10
        }
        
        label {text 'First &Name: '}
        text {
          fill_horizontally_layout_data
          text <=> [@contact, :first_name]
        }
        
        label {text '&Last Name: '}
        text {
          fill_horizontally_layout_data
          text <=> [@contact, :last_name]
        }
        
        label {text '&Year of Birth: '}
        text {
          fill_horizontally_layout_data
          text <=> [@contact, :year_of_birth]
        }
        
        label {text 'Name: '}
        label {
          fill_horizontally_layout_data
          text <= [@contact, :name, computed_by: [:first_name, :last_name]]
        }
        
        label {text 'Age: '}
        label {
          fill_horizontally_layout_data
          text <= [@contact, :age, on_write: :to_i, computed_by: [:year_of_birth]]
        }
      }
    }
  }
  
  def fill_horizontally_layout_data
    layout_data {
      horizontal_alignment :fill
      grab_excess_horizontal_space true
    }
  end
end

HelloComputed.launch
