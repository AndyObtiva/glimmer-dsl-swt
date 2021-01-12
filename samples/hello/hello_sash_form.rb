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

class SashFormPresenter
  include Glimmer
  
  attr_accessor :sash_width, :orientation, :orientation_style
  
  def initialize
    @sash_width = 10
    self.orientation = 'horizontal'
  end
  
  def orientation_options
    ['horizontal', 'vertical']
  end
  
  def orientation=(value)
    @orientation = value
    self.orientation_style = swt(@orientation)
  end
end

@presenter = SashFormPresenter.new

include Glimmer

shell {
  grid_layout 1, false
  minimum_size 740, 0
  text 'Hello, Sash Form!'
  
  @sash_form = sash_form {
    layout_data(:fill, :fill, true, true) {
      height_hint 200
    }
    sash_width bind(@presenter, :sash_width)
    orientation bind(@presenter, :orientation_style)
    weights 1, 2
    
    @green_label = label {
      text 'Hello, (resize >>)'
      background :dark_green
      foreground :white
      font height: 30
    }
    
    @red_label = label {
      text '(<< resize) Sash Form!'
      background :red
      foreground :white
      font height: 30
    }
  }
  
  composite {
    layout_data(:fill, :fill, true, true)
    grid_layout 2, true
    
    label {
      layout_data(:right, :center, true, false)
      text 'Sash Width:'
      font height: 16
    }
    spinner {
      layout_data(:fill, :center, true, false) {
        width_hint 100
      }
      selection bind(@presenter, :sash_width)
      font height: 16
    }
    
    label {
      layout_data(:right, :center, true, false)
      text 'Orientation:'
      font height: 16
    }
    combo(:read_only, :border) {
      layout_data(:fill, :center, true, false) {
        width_hint 100
      }
      selection bind(@presenter, :orientation)
      font height: 16
    }
    
    button {
      layout_data(:fill, :center, true, false)
      text 'Maximize Green Label'
      foreground :dark_green
      font height: 16
      
      on_widget_selected {
        @sash_form.maximized_control = @green_label.swt_widget
      }
    }
    button {
      layout_data(:fill, :center, true, false)
      text 'Maximize Red Label'
      foreground :red
      font height: 16
      
      on_widget_selected {
        @sash_form.maximized_control = @red_label.swt_widget
      }
    }
    
    button {
      layout_data(:fill, :center, true, false) {
        horizontal_span 2
      }
      text 'Maximize None'
      font height: 16
      
      on_widget_selected {
        @sash_form.maximized_control = nil
      }
    }
  }
}.open
