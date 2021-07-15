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

class HelloLabel
  include Glimmer::UI::CustomShell
  
  body {
    shell {
      text 'Hello, Label!'
    
      tab_folder {
        tab_item {
          text 'left-aligned'
          
          grid_layout 2, true
          
          1.upto(3) do |n|
            label(:left) { # :left is default in English, so it is unnecessary
              layout_data :fill, :center, true, false
              text "Field #{n}"
            }
            text {
              layout_data :fill, :center, true, false
              text "Enter Field #{n}"
            }
          end
        }
        
        tab_item {
          text 'center-aligned'
          
          grid_layout 2, true
          
          1.upto(3) do |n|
            label(:center) {
              layout_data :fill, :center, true, false
              text "Field #{n}"
            }
            text {
              layout_data :fill, :center, true, false
              text "Enter Field #{n}"
            }
          end
        }
        
        tab_item {
          text 'right-aligned'
          
          grid_layout 2, true
          
          1.upto(3) do |n|
            label(:right) {
              layout_data :fill, :center, true, false
              text "Field #{n}"
            }
            text {
              layout_data :fill, :center, true, false
              text "Enter Field #{n}"
            }
          end
        }
        
        tab_item {
          text 'images'
          
          grid_layout 2, true
          
          ['denmark', 'finland', 'norway'].each do |image_name|
            label {
              layout_data :fill, :center, true, false
              image File.expand_path("images/#{image_name}.png", __dir__)
            }
            text {
              layout_data :fill, :center, true, false
              text "Enter Field #{image_name.capitalize}"
            }
          end
        }
        
        tab_item {
          text 'background images'
          
          grid_layout 2, true
          
          ['italy', 'france', 'mexico'].each do |image_name|
            label {
              layout_data :center, :center, true, false
              background_image File.expand_path("images/#{image_name}.png", __dir__)
              text image_name.capitalize
              font height: 26, style: :bold
            }
            text {
              layout_data :fill, :center, true, false
              text "Enter Field #{image_name.capitalize}"
            }
          end
        }
        
        tab_item {
          text 'horizontal separator'
          
          grid_layout 2, true

          label {
            layout_data :fill, :center, true, false
            text "Field 1"
          }
          text {
            layout_data :fill, :center, true, false
            text "Enter Field 1"
          }

          label(:separator, :horizontal) {
            layout_data(:fill, :center, true, false) {
              horizontal_span 2
            }
          }
                    
          label {
            layout_data :fill, :center, true, false
            text "Field 2"
          }
          text {
            layout_data :fill, :center, true, false
            text "Enter Field 2"
          }
        }
        
        tab_item {
          text 'vertical separator'
          
          grid_layout 3, true

          label {
            layout_data :fill, :center, true, false
            text "Field 1"
          }
          label(:separator, :vertical) {
            layout_data(:center, :center, false, false) {
              vertical_span 3
            }
          }
          text {
            layout_data :fill, :center, true, false
            text "Enter Field 1"
          }

          label {
            layout_data :fill, :center, true, false
            text "Field 2"
          }
          text {
            layout_data :fill, :center, true, false
            text "Enter Field 2"
          }

          label {
            layout_data :fill, :center, true, false
            text "Field 3"
          }
          text {
            layout_data :fill, :center, true, false
            text "Enter Field 3"
          }
        }
        
      }
      
    }
    
  }
end

HelloLabel.launch
