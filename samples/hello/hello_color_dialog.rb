# Copyright (c) 2007-2025 Andy Maleh
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

class HelloColorDialog
  include Glimmer::UI::CustomShell
  
  attr_accessor :selected_color
  
  before_body do
    self.selected_color = :black
  end
  
  body {
    shell {
      minimum_size 220, 0
      grid_layout
      
      text 'Hello, Color Dialog!'
      
      label {
        layout_data :center, :center, true, false
        text 'Selected Color:'
        font height: 14, style: :bold
      }
      
      canvas(:border) {
        layout_data :center, :center, true, false
        background <=> [self, :selected_color]
        
        on_mouse_up do
          self.selected_color = color_dialog.open
        end
      }
      
      button {
        layout_data :center, :center, true, false
        text "Choose Color..."
        
        on_widget_selected do
          self.selected_color = color_dialog.open
        end
      }
      
    }
  }
end

HelloColorDialog.launch
