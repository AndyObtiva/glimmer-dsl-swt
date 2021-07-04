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

class HelloLayout
  include Glimmer::UI::CustomShell
  
  body {
    shell {
      # shell (which is a composite) has fill_layout(:horizontal) by default with no margins
      text 'Hello, Layout!'
      tab_folder {
      
        # every tab item has its own composite, which can set a layout
        tab_item {
          text 'Fill Layout (horizontal)'
          
          fill_layout(:horizontal) {
            margin_width 30
            margin_height 40
            spacing 5
          }
          
          10.times { |n|
            label {
              text "<label #{n+1}>"
            }
          
          }
        
        }
      
        tab_item {
          text 'Fill Layout (vertical)'
          
          fill_layout {
            type :vertical # alternative way of specifying orientation
            margin_width 40
            margin_height 30
            spacing 10
          }
          
          10.times { |n|
            label(:center) {
              text "<label #{n+1}>"
            }
          
          }
        
        }
      
        tab_item {
          text 'Row Layout (horizontal)'
          
          row_layout(:horizontal) {
            # row layout has margin attributes for top, left, right, and bottom
            # in addition to width and height (and sets margin_width and margin_height to 5 by default)
            margin_top 40
            margin_left 30
            spacing 5
            wrap false
            center true
            justify true
          }
          
          10.times { |n|
            label {
              text "<label #{n+1}>"
            }
          
          }
        
        }
      
        tab_item {
          text 'Row Layout (wrap on shrink)'
          
          row_layout { # :horizontal is the default type
            margin_height 40
            margin_width 30
            spacing 35
            # wrap true # is the default
          }
          
          10.times { |n|
            label {
              text "<label #{n+1}>"
            }
          
          }
        
        }
        
        tab_item {
          text 'Row Layout (vertical)'
          background :yellow

          row_layout(:vertical) { |l|
            margin_height 0
            margin_width 0
            spacing 10
            fill true # fills horizontally to match the widest child (opposite to row layout orientation)
            center false # enable and disable fill to see what this does
          }

          10.times { |n|
            label {
              # layout_data allows a widget to tweak its layout configuration (generating RowData object for RowLayout)
              layout_data {
                height 30
#                 width unspecified yet calculated
              }
              text "<this is a ver#{'r'*(rand*200).to_i}y wide label #{n+1}>"
              background :green
            }

          }

        }
            
        tab_item {
          text 'Grid Layout'
          
          grid_layout {
            num_columns 5
            make_columns_equal_width true
            horizontal_spacing 15
            vertical_spacing 10

            # grid layout has margin attributes for top, left, right, and bottom
            # in addition to width and height (and sets margin_width and margin_height to 5 by default)
            margin_height 0
            margin_top 20
          }
          
          10.times { |n|
            label {
              text "<this label is wide enough to fill #{n+1}>"
              background :white
            }
          }
        
          label {
            # layout_data allows a widget to tweak its layout configuration (generating GridData object for GridLayout)
            layout_data {
              width_hint 120
              height_hint 40
            }
            text "<this label is clipped>"
            background :cyan
          }
        
          label {
            # layout_data allows a widget to tweak its layout configuration (generating GridData object for GridLayout)
            layout_data {
              horizontal_span 2
            }
            text "<this label spans two columns, so it can contain more text than normal>"
            background :green
          }
        
          label {
            # layout_data allows a widget to tweak its layout configuration (generating GridData object for GridLayout)
            layout_data {
              vertical_span 2
              vertical_alignment :fill
            }
            text "<this label spans two rows, \nso it can contain new lines\n1\n2\n3\n4\n5\n6\n7>"
            background :yellow
          }
          
          5.times { label } # just filler
          
          label {
            
            # layout_data allows a widget to tweak its layout configuration (generating GridData object for GridLayout)
            layout_data {
              horizontal_span 5
              horizontal_alignment :fill # could be :beginning, :center or :end too
              vertical_alignment :fill # could be :beginning, :center, or :end too
              grab_excess_horizontal_space true
              grab_excess_vertical_space true
            }
            
            # this is a short alternative for specifying what is above
#             layout_data(:fill, :fill, true, true) {
#               horizontal_span 5
#             }
            
            text "<this label fills all the space it can get\nhorizontally and vertically>"
            background :magenta
          }
        
        }
        
            
        tab_item {
          text 'Grid Layout (non-equal columns)'
          
          grid_layout(2, false) # alt syntax: (numColumns, make_columns_equal_width)
          
          10.times { |n|
            label {
              text "Field #{n+1}"
            }
            text {
              layout_data {
                width_hint 600
              }
              
              text "Please enter text"
            }
          }
        
        }
                                  
      }
    
    }
  
  }
end

HelloLayout.launch
