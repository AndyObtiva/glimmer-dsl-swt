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

include Glimmer

shell {
  row_layout :vertical
  
  text 'Hello, Dialog!'
  
  7.times {|n|
    dialog_number = n + 1
    
    button {
      layout_data {
        width 200
        height 50
      }
      text "Dialog #{dialog_number}"
      
      on_widget_selected {
        dialog { |dialog_proxy|
          row_layout(:vertical) {
            center true
          }
          
          text "Dialog #{dialog_number}"
          
          label(:center) {
            text "Given `dialog` is modal, you cannot interact with app closed.\nUnlike `message_box`, `dialog` can contain arbitrary widgets."
          }
          composite {
            row_layout {
              margin_height 0
              margin_top 0
              margin_bottom 0
            }

            radio {
              text 'Radio'
            }
            checkbox {
              text 'Checkbox'
            }
            text {
              text 'Text'
            }
          }
          button {
            text 'Close'
            
            on_widget_selected {
              dialog_proxy.close
            }
          }
        }.open
      }
    }
  }
}.open
