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

class HelloLink
  include Glimmer::UI::CustomShell
  
  body {
    shell { |main_shell|
      grid_layout {
        margin_width 20
        margin_height 10
      }
      
      background :white
      text 'Hello, Link!'
      
      @link = link {
        background :white
        link_foreground :dark_green
        font height: 16
        text <<~MULTI_LINE_STRING
        
          You may click on any <a>link</a> to get help.
          
          How do you know <a href="which-link-href-value">which link</a> you clicked?
          
          Just keep clicking <a href="all links">links</a> to find out!
        MULTI_LINE_STRING
            
        on_widget_selected { |selection_event|
          # This retrieves the clicked link href (or contained text if no href is set)
          @selected_link = selection_event.text
        }
        on_mouse_up { |mouse_event|
          unless @selected_link.nil?
            @help_shell.close unless @help_shell.nil? || @help_shell.disposed?
            @help_shell = shell(:no_trim) {
              grid_layout {
                margin_width 10
                margin_height 10
              }
              
              background :yellow
              
              label {
                background :yellow
                text "Did someone ask for help about \"#{@selected_link}\"?\nYou don't really need help. You did it!"
              }
              
              on_swt_show {
                x = main_shell.location.x + @link.location.x + mouse_event.x
                y = main_shell.location.y + @link.location.y + mouse_event.y + 20
                @help_shell.location = Point.new(x, y)
              }
              on_focus_lost {
                @selected_link = nil
                @help_shell.close
              }
            }
            @help_shell.open
          end
        }
      }
    }
  }
end

HelloLink.launch
