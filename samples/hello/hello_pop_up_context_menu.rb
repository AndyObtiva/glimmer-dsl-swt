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
  grid_layout {
    margin_width 0
    margin_height 0
  }
  
  text 'Hello, Pop Up Context Menu!'
  
  label {
    text "Right-Click on the Text to\nPop Up a Context Menu"
    font height: 50
    
    menu {
      menu {
        text '&History'
        
        menu {
          text '&Recent'
          
          menu_item {
            text 'File 1'
            
            on_widget_selected do
              message_box {
                text 'File 1'
                message 'File 1 Contents'
              }.open
            end
          }
          
          menu_item {
            text 'File 2'
            
            on_widget_selected do
              message_box {
                text 'File 2'
                message 'File 2 Contents'
              }.open
            end
          }
        }
        
        menu {
          text '&Archived'
          
          menu_item {
            text 'File 3'
            
            on_widget_selected do
              message_box {
                text 'File 3'
                message 'File 3 Contents'
              }.open
            end
          }
          
          menu_item {
            text 'File 4'
            
            on_widget_selected do
              message_box {
                text 'File 4'
                message 'File 4 Contents'
              }.open
            end
          }
        }
      }
    }
  }
}.open
