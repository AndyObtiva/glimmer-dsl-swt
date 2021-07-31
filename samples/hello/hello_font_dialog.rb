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

class HelloFontDialog
  include Glimmer::UI::CustomShell
  
  attr_accessor :selected_font_data
  
  before_body do
    @selected_font_data = FontData.new('Times New Roman', 40, swt(:bold))
  end
  
  body {
    shell {
      grid_layout {
        margin_width 15
        margin_width 15
      }
      minimum_size 400, 0
      
      text 'Hello, Font Dialog!'
      
      label {
        text 'Selected Font:'
        font height: 14, style: :bold
      }
      
      label(:center) {
        layout_data(:fill, :center, true, true) {
          vertical_indent 15
          height_hint 200
        }
        background :white
        font <=> [self, 'selected_font_data']
        text <=> [self, 'selected_font_data', on_read: ->(font_data) {
          style = case font_data.style
          when swt(:normal)
            'Normal'
          when swt(:italic)
            'Italic'
          when swt(:bold)
            'Bold'
          when swt(:bold, :italic)
            'Bold Italic'
          end
          "#{font_data.name}\n#{font_data.height}\n#{style}"
        }]
      }
      
      button {
        text "Choose Font..."
        
        on_widget_selected {
          self.selected_font_data = font_dialog {
            font_list [@selected_font_data]
          }.open
        }
      }
      
    }
  }
end

HelloFontDialog.launch
