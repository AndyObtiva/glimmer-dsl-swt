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

class HelloPrint
  include Glimmer::UI::CustomShell
  
  body {
    shell {
      text 'Hello, Print!'
      @composite = composite {
        row_layout(:vertical) {
          fill true
          center true
        }
        
        label(:center) {
          text "Whatever you see inside the app composite\nwill get printed when clicking the Print button."
          font height: 16
        }
         
        button {
          text 'Print'
          
          on_widget_selected do
            # The widget#print method automates all the work seen in Hello, Print Dialog!
            # the caveat is it assumes everything fits on one page
            unless @composite.print
              message_box {
                text 'Unable To Print'
                message 'Sorry! Printing is not supported on this platform!'
              }.open
            end
          end
        }
      }
    }
  }
end

HelloPrint.launch
