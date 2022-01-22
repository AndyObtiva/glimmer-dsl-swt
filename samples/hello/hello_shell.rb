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

class HelloShell
  include Glimmer::UI::CustomShell
  
  body {
    # this is the initial shell that opens. If you close it, you close the app.
    shell { |root_shell_proxy|
      row_layout(:vertical)
      text 'Hello, Shell!'
        
      button {
        layout_data {
          width 200
          height 50
        }
        text "Nested Shell"
        
        on_widget_selected {
          # build a nested shell, meaning a shell that specifies its parent shell (root_shell_proxy)
          shell(root_shell_proxy) {
            # shell has fill_layout(:horizontal) by default with no margins
            text 'Nested Shell'
            
            label {
              font height: 20
              text "Since this shell is nested, \nyou can hit ESC to close"
            }
          }.open
        }
      }
        
      button {
        layout_data {
          width 200
          height 50
        }
        text "Independent Shell"
        
        on_widget_selected {
          # build an independent shell, meaning a shell that is independent of its parent
          shell {
            # shell has fill_layout(:horizontal) by default with no margins
            text 'Independent Shell'
            
            label {
              font height: 20
              text "Since this shell is independent, \nyou cannot close by hitting ESC"
            }
          }.open
        }
      }
        
      button {
        layout_data {
          width 200
          height 50
        }
        text "Close-Button Shell"
        
        on_widget_selected {
          shell(:close) {
            # shell has fill_layout(:horizontal) by default with no margins
            text 'Nested Shell'
            
            label {
              font height: 20
              text "Shell with close button only\n(varies per platform)"
            }
          }.open
        }
      }
        
      button {
        layout_data {
          width 200
          height 50
        }
        text "Minimize-Button Shell"
        
        on_widget_selected {
          # build a nested shell, meaning a shell that specifies its parent shell (root_shell_proxy)
          shell(root_shell_proxy, :min) {
            # shell has fill_layout(:horizontal) by default with no margins
            text 'Minimize-Button Shell'
            
            label {
              font height: 20
              text "Shell with minimize button only\n(varies per platform)"
            }
          }.open
        }
      }
        
      button {
        layout_data {
          width 200
          height 50
        }
        text "Maximize-Button Shell"
        
        on_widget_selected {
          # build a nested shell, meaning a shell that specifies its parent shell (root_shell_proxy)
          shell(root_shell_proxy, :max) {
            # shell has fill_layout(:horizontal) by default with no margins
            text 'Maximize-Button Shell'
            
            label {
              font height: 20
              text "Shell with maximize button only\n(varies per platform)"
            }
          }.open
        }
      }
        
      button {
        layout_data {
          width 200
          height 50
        }
        text "Buttonless Shell"
        
        on_widget_selected {
          # build a nested shell, meaning a shell that specifies its parent shell (root_shell_proxy)
          shell(root_shell_proxy, :title) {
            # shell has fill_layout(:horizontal) by default with no margins
            text 'Buttonless Shell'
            
            label {
              font height: 20
              text "Buttonless shell (title only)\n(varies per platform)"
            }
          }.open
        }
      }
        
      button {
        layout_data {
          width 200
          height 50
        }
        text "No Trim Shell"
        
        on_widget_selected {
          # build a nested shell, meaning a shell that specifies its parent shell (root_shell_proxy)
          shell(root_shell_proxy, :no_trim) {
            # shell has fill_layout(:horizontal) by default with no margins
            text 'No Trim Shell'
            
            label {
              font height: 20
              text "No trim shell, meaning no buttons or title bar.\n(varies per platform)"
            }
          }.open
        }
      }
        
      button {
        layout_data {
          width 200
          height 50
        }
        text "Always On Top Shell"
        
        on_widget_selected {
          # build a nested shell, meaning a shell that specifies its parent shell (root_shell_proxy)
          shell(root_shell_proxy, :on_top) {
            # shell has fill_layout(:horizontal) by default with no margins
            text 'Always On Top Shell'
            
            label {
              font height: 20
              text "Always on top shell.\n(varies per platform)"
            }
          }.open
        }
      }
        
    }
  
  }
end

HelloShell.launch
