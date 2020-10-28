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

class HelloExpandBar
  include Glimmer
  
  def launch
    shell {
      grid_layout(1, false) {
        margin_width 0
        margin_height 0
      }
      minimum_size 320, 240
      text 'Hello, Expand Bar!'
      
      @status_label = label(:center) {
        text ' '
        layout_data :fill, :center, true, false
        font height: 24
      }
      
      expand_bar {
        layout_data :fill, :fill, true, true
        
        expand_item {
          text 'Productivity'
          
          button {
            text 'Word Processing'
          }
          button {
            text 'Spreadsheets'
          }
          button {
            text 'Presentations'
          }
          button {
            text 'Database'
          }
          composite # just filler
        }
        
        expand_item {
          text 'Tools'
          
          button {
            text 'Calculator'
          }
          button {
            text 'Unit Converter'
          }
          button {
            text 'Currency Converter'
          }
          button {
            text 'Scientific Calculator'
          }
          composite # just filler
        }
        
        expand_item {
          text 'Reading'
          
          button {
            text 'eBooks'
          }
          button {
            text 'News'
          }
          button {
            text 'Blogs'
          }
          button {
            text 'Papers'
          }
          composite # just filler
        }
        
        on_item_expanded { |expand_event|
          @status_label.text = "#{expand_event.item.text} Expanded!"
        }
        
        on_item_collapsed { |expand_event|
          @status_label.text = "#{expand_event.item.text} Collapsed!"
        }
        
      }
    }.open
  end
end

HelloExpandBar.new.launch
