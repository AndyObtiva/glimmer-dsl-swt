# Copyright (c) 2007-2023 Andy Maleh
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

class HelloToggle
  include Glimmer::UI::CustomShell
  
  attr_accessor :red, :green, :blue, :final_color_text, :final_color
  
  after_body do
    observe(self, :red) do
      update_final_color!
    end
    
    observe(self, :green) do
      update_final_color!
    end
    
    observe(self, :blue) do
      update_final_color!
    end
  end
  
  body {
    shell {
      grid_layout 3, true
       
      text 'Hello, Toggle!'
       
      toggle {
        layout_data :fill, :center, true, false
        text 'Red'
        
        selection <=> [self, :red]
      }

      toggle {
        layout_data :fill, :center, true, false
        text 'Green'
        
        selection <=> [self, :green]
      }

      toggle {
        layout_data :fill, :center, true, false
        text 'Blue'
        
        selection <=> [self, :blue]
      }
      
      label(:center) {
        layout_data {
          horizontal_span 3
          horizontal_alignment :fill
          grab_excess_horizontal_space true
          height_hint 20
        }
        
        text <= [self, :final_color_text]
        background <= [self, :final_color]
      }
    }
  }
  
  def update_final_color!
    final_color_symbols = [:red, :green, :blue].map {|color| send(color) ? color : nil}.compact
    self.final_color_text = final_color_symbols.map {|color_symbol| color_symbol.to_s.capitalize}.join(' + ')
    self.final_color = final_color_symbols.map {|color_symbol| color(color_symbol)}.reduce {|output_color, color| rgb(output_color.red + color.red, output_color.green + color.green, output_color.blue + color.blue) }
  end
end

HelloToggle.launch
