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

include Glimmer

shell {
  row_layout(:vertical) {
    fill true
    center true
  }
  
  text 'Hello, Arrow!'
  
  label(:center) {
    text 'Click the arrow to get a menu.'
  }
  
  arrow { # can be customized by passing `:arrow` SWT style + `:left`, `:right`, `:up`, or `:down` (default)
    menu {
      menu_item {
        text 'Item &1'
        
        on_widget_selected do
          message_box {
            text 'Item 1'
            message 'Item 1 selected!'
          }.open
        end
      }
      menu_item {
        text 'Item &2'
        
        on_widget_selected do
          message_box {
            text 'Item 2'
            message 'Item 2 selected!'
          }.open
        end
      }
    }
    
    on_widget_selected do |event|
      event.widget.menu.visible = true
    end
  }
    
}.open
