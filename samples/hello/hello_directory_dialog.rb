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

class HelloDirectoryDialog
  include Glimmer::UI::CustomShell
  
  attr_accessor :selected_directory
  
  before_body do
    @selected_directory = 'Please select a directory.'
  end
  
  body {
    shell {
      minimum_size 400, 0
      grid_layout
      
      text 'Hello, Directory Dialog!'
      
      label {
        text 'Selected Directory:'
        font height: 14, style: :bold
      }
      
      label {
        layout_data :fill, :center, true, false
        text <= [self, :selected_directory]
        font height: 14
      }
      
      button {
        text "Browse..."
        
        on_widget_selected {
          self.selected_directory = directory_dialog.open
        }
      }
    }
  }
end

HelloDirectoryDialog.launch
