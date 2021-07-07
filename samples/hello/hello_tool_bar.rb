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

class HelloToolBar
  include Glimmer::UI::CustomShell
  
  attr_accessor :operation, :font_size
  
  def font_size_options
    (10..30).to_a.map(&:to_s)
  end
  
  before_body {
    self.font_size = '30'
  }

  body {
    shell {
      fill_layout(:vertical) {
        margin_width 0
        margin_height 0
      }
      
      text 'Hello, Tool Bar!'
      
      tool_bar { # optionally takes a :flat style, :wrap style if you need wrapping upon shrinking window, and :vertical style if you need vertical layout
        tool_item {
          image cut_image # alternatively you can pass an image file path
          
          on_widget_selected do
            self.operation = 'Cut'
          end
        }
        tool_item {
          image copy_image # alternatively you can pass an image file path
          
          on_widget_selected do
            self.operation = 'Copy'
          end
        }
        tool_item {
          image paste_image # alternatively you can pass an image file path
          
          on_widget_selected do
            self.operation = 'Paste'
          end
        }
        tool_item(:separator)
        tool_item {
          text 'Font Size'
        }
        # a combo can be nested in a tool_bar (it auto-generates a tool_item for itself behind the scenes)
        combo {
          selection <=> [self, :font_size]
        }
      }
  
      label {
        font <= [self, :font_size, on_read: ->(size) { {height: size.to_i} }]
        text <= [self, :operation]
        text <= [self, :font_size]
      }
    }
  }
  
  def cut_image
    # building image on the fly with Canvas Shape DSL
    image(25, 25) {
      rectangle(0, 0, 25, 25) {
        background_pattern 0, 0, 0, 25, :white, :gray
        line(20, 2, 9, 15) {
          line_width 2
        }
        line(5, 2, 16, 15) {
          line_width 2
        }
        oval(2, 15, 8, 8) {
          line_width 2
        }
        oval(16, 15, 8, 8) {
          line_width 2
        }
      }
    }
  end
  
  def copy_image
    # building image on the fly with Canvas Shape DSL
    image(25, 25) {
      rectangle(0, 0, 25, 25) {
        background_pattern 0, 0, 0, 25, :white, :gray
        rectangle([:default, 2], [:default, -2], 14, 14, 5, 5) {
          line_width 2
        }
        rectangle([:default, -2], [:default, 2], 14, 14, 5, 5) {
          line_width 2
        }
      }
    }
  end
  
  def paste_image
    image(25, 25) {
      rectangle(0, 0, 25, 25) {
        background_pattern 0, 0, 0, 25, :white, :gray
        rectangle(:default, [:default, 1], 15, 20, 5, 5) {
          line_width 2
        }
        line(7, 8, 18, 8) {
          line_width 2
        }
        line(7, 13, 18, 13) {
          line_width 2
        }
        line(7, 18, 18, 18) {
          line_width 2
        }
      }
    }
  end
end

HelloToolBar.launch
