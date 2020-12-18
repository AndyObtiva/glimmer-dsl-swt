# Copyright (c) 2007-2020 Andy Maleh
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

COLORS = [:white, :red, :yellow, :green, :blue, :magenta, :gray, :black]

shell {
  grid_layout {
    margin_width 0
    margin_height 0
  }
  
  text 'Hello, Menu Bar!'
  
  @label = label(:center) {
    font height: 50
    text 'Check Out The Menu Bar Above!'
  }
  
  menu_bar {
    menu {
      text '&File'
      menu_item {
        text '&New'
        accelerator :command, :N
        
        on_widget_selected {
          message_box {
            text 'New'
            message 'New file created.'
          }.open
        }
      }
      menu_item {
        text '&Open...'
        accelerator :command, :O
        
        on_widget_selected {
          message_box {
            text 'Open'
            message 'Opening File...'
          }.open
        }
      }
      menu {
        text 'Open &Recent'
        menu_item {
          text 'File 1'
          on_widget_selected {
            message_box {
              text 'File 1'
              message 'File 1 Contents'
            }.open
          }
        }
        menu_item {
          text 'File 2'
          on_widget_selected {
            message_box {
              text 'File 2'
              message 'File 2 Contents'
            }.open
          }
        }
      }
      menu_item(:separator)
      menu_item {
        text 'E&xit'
        
        on_widget_selected {
          exit(0)
        }
      }
    }
    menu {
      text '&Edit'
      menu_item {
        text 'Cut'
        accelerator :command, :X
      }
      menu_item {
        text 'Copy'
        accelerator :command, :C
      }
      menu_item {
        text 'Paste'
        accelerator :command, :V
      }
    }
    menu {
      text '&Options'
      
      menu_item(:radio) {
        text '&Enabled'
        
        on_widget_selected {
          @select_one_menu.enabled = true
          @select_multiple_menu.enabled = true
        }
      }
      @select_one_menu = menu {
        text '&Select One'
        enabled false
        
        menu_item(:radio) {
          text 'Option 1'
        }
        menu_item(:radio) {
          text 'Option 2'
        }
        menu_item(:radio) {
          text 'Option 3'
        }
      }
      @select_multiple_menu = menu {
        text '&Select Multiple'
        enabled false
        
        menu_item(:check) {
          text 'Option 4'
        }
        menu_item(:check) {
          text 'Option 5'
        }
        menu_item(:check) {
          text 'Option 6'
        }
      }
    }
    menu {
      text '&Format'
      menu {
        text '&Background Color'
        COLORS.each { |color_style|
          menu_item(:radio) {
            text color_style.to_s.split('_').map(&:capitalize).join(' ')
            
            on_widget_selected {
              @label.background = color_style
            }
          }
        }
      }
      menu {
        text 'Foreground &Color'
        COLORS.each { |color_style|
          menu_item(:radio) {
            text color_style.to_s.split('_').map(&:capitalize).join(' ')
            
            on_widget_selected {
              @label.foreground = color_style
            }
          }
        }
      }
    }
    menu {
      text '&View'
      menu_item(:radio) {
        text 'Small'
        
        on_widget_selected {
          @label.font = {height: 25}
          @label.parent.pack
        }
      }
      menu_item(:radio) {
        text 'Medium'
        selection true
        
        on_widget_selected {
          @label.font = {height: 50}
          @label.parent.pack
        }
      }
      menu_item(:radio) {
        text 'Large'
        
        on_widget_selected {
          @label.font = {height: 75}
          @label.parent.pack
        }
      }
    }
    menu {
      text '&Help'
      menu_item {
        text '&Manual'
        accelerator :command, :shift, :M
        
        on_widget_selected {
          message_box {
            text 'Manual'
            message 'Manual Contents'
          }.open
        }
      }
      menu_item {
        text '&Tutorial'
        accelerator :command, :shift, :T
        
        on_widget_selected {
          message_box {
            text 'Tutorial'
            message 'Tutorial Contents'
          }.open
        }
      }
      menu_item(:separator)
      menu_item {
        text '&Report an Issue...'
        
        on_widget_selected {
          message_box {
            text 'Report an Issue'
            message 'Reporting an issue...'
          }.open
        }
      }
    }
  }
}.open
