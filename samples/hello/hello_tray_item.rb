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

class HelloTrayItem
  include Glimmer::UI::CustomShell
  
  # boolean that indicates if application is visible
  attr_accessor :show_application
  
  before_body {
    # application starts visible
    @show_application = true
    # pre-render an icon image using the Canvas Shape DSL
    @image = image(16, 16) {
      rectangle(0, 0, 16, 16) {
        background :black
      }
      oval(1, 1, [:default, - 2], [:default, - 2]) {
        foreground :white
      }
      oval(3, 3, [:default, - 6], [:default, - 6]) {
        foreground :white
      }
      oval(5, 5, [:default, - 10], [:default, - 10]) {
        foreground :white
      }
      oval(7, 7, [:default, - 14], [:default, - 14]) {
        foreground :white
      }
    }
  }
  
  body {
    shell(:shell_trim, :on_top) { # make it always appear on top of everything
      row_layout(:vertical) {
        center true
      }
      text 'Hello, Tray Item!'
      
      on_shell_closed do |event|
        # do not perform event that closes app when shell is closed
        event.doit = false
        # body_root is the root shell
        body_root.hide
        self.show_application = false # updates Show Application checkbox menu item indirectly
      end
      
      tray_item {
        tool_tip_text 'Glimmer'
        image @image # could use an image path instead

        menu {
          menu_item {
            text 'About'

            on_widget_selected do
              message_box {
                text 'Glimmer - About'
                message 'This is a Glimmer DSL for SWT Tray Item'
              }.open
            end
          }
          menu_item(:separator)
          menu_item(:check) {
            text 'Show Application'
            selection <=> [self, :show_application]
            
            on_widget_selected do
              # body_root is the root shell
              if body_root.visible?
                body_root.hide
              else
                body_root.show
              end
            end
          }
          menu_item(:separator)
          menu_item {
            text 'Exit'

            on_widget_selected {
              exit(0)
            }
          }
        }
        
        # supported tray item listeners (you can try to add actions to them when needed)
#         on_swt_Show {
#         }
#
#         on_swt_Hide {
#         }
#
#         on_widget_selected {
#         }
#
#         on_menu_detected {
#         }
      }
      
      label(:center) {
        text 'This is the application'
        font height: 30
      }
      label {
        text 'Click on the tray item (circles icon) to open its menu'
      }
      label {
        text 'Uncheck Show Application to hide the app and recheck it to show the app'
      }
    }
  }
end

HelloTrayItem.launch
