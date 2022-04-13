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

class HelloCodeText
  include Glimmer::UI::CustomShell
  
  attr_accessor :ruby_code, :js_code, :html_code
  
  before_body do
    self.ruby_code = <<~RUBY
      greeting = 'Hello, World!'
      
      include Glimmer
      
      shell {
        text 'Glimmer'
        
        label {
          text greeting
          font height: 30, style: :bold
        }
      }.open
    RUBY
    
    self.js_code = <<~JS
      function greet(greeting) {
        alert(greeting);
      }
      
      var greetingString = 'Hello, World!';
      
      greet(greetingString);
      
      var moreGreetings = ['Howdy!', 'Aloha!', 'Hey!']
      
      for(var greeting of moreGreetings) {
        greet(greeting)
      }
    JS
    
    self.html_code = <<~HTML
      <html>
        <body>
          <section class="accordion">
            <form method="post" id="name">
              <label for="name">
                Name
              </label>
              <input name="name" type="text" />
              <input type="submit" />
            </form>
          </section>
        </body>
      </html>
    HTML
  end
  
  body {
    shell {
      minimum_size 640, 480
      text 'Hello, Code Text!'
      
      tab_folder {
        tab_item {
          fill_layout
          
          text 'Ruby (glimmer theme)'
          
          code_text(language: 'ruby', theme: 'glimmer', lines: true) {
            text <=> [self, :ruby_code]
          }
        }
        
        tab_item {
          fill_layout
          
          text 'JavaScript (pastie theme)'
          
          code_text(:multi, :h_scroll, :v_scroll, language: 'javascript', theme: 'pastie', lines: {width: 2}) {
            root {
              grid_layout(2, false) {
                margin_width 2
              }
              
              background :white
            }
            
            line_numbers {
              background :white
            }
            
            text <=> [self, :js_code]
          }
        }
        
        tab_item {
          fill_layout
          
          text 'HTML (github theme)'
          
          code_text(language: 'html', theme: 'github') { # default is lines: false
            text <=> [self, :html_code]
          }
        }
      }
    }
  }
  
end

HelloCodeText.launch
