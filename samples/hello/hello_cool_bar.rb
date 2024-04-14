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

class HelloCoolBar
  include Glimmer::UI::CustomShell
  
  attr_accessor :operation, :font_size
  
  def font_size_options
    (10..30).to_a.map(&:to_s)
  end
  
  before_body do
    self.font_size = '30'
  end

  body {
    shell {
      fill_layout(:vertical) {
        margin_width 0
        margin_height 0
      }

      text 'Hello, Cool Bar!'
      minimum_size 280, 50
      
      cool_bar { # optionally takes a :flat style and/or :vertical style if you need vertical layout
        tool_bar {
          tool_item {
            image File.expand_path('./images/cut.png', __dir__), height: 16
            
            on_widget_selected do
              self.operation = 'Cut'
            end
          }
          tool_item {
            image File.expand_path('./images/copy.png', __dir__), height: 16
            
            on_widget_selected do
              self.operation = 'Copy'
            end
          }
          tool_item {
            image File.expand_path('./images/paste.png', __dir__), height: 16
            
            on_widget_selected do
              self.operation = 'Paste'
            end
          }
        }
        tool_bar {
          tool_item {
            text 'Font Size'
          }
          # a combo can be nested in a tool_bar (it auto-generates a tool_item for itself behind the scenes)
          combo {
            selection <=> [self, :font_size]
          }
        }
      }
      
  
      label {
        font <= [self, :font_size, on_read: ->(size) { {height: size.to_i} }]
        text <= [self, :operation]
        text <= [self, :font_size]
      }
    }
  }
end

HelloCoolBar.launch
