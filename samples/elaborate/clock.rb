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

class Clock
  include Glimmer::UI::CustomShell
  
  body {
    shell {
      text 'Glimmer Clock'
      minimum_size 400, 430
    
      canvas {
        initial_time = Time.now
        background :black
        
        animation {
          every 0.01 # every hundredth of a second to ensure higher accuracy
                
          frame { |index|
            time = Time.now
          
            oval(0, 0, 400, 400) {
              background :white
            }
            polygon(-5, -5, 180, 0, -5, 5) {
              background :black
              
              transform {
                translate 200, 200
                rotate(time.sec*6 - 90)
              }
            }
            polygon(-5, -5, 135, 0, -5, 5) {
              background :dark_gray
              
              transform {
                translate 200, 200
                rotate(time.min*6 - 90)
              }
            }
            polygon(-5, -5, 90, 0, -5, 5) {
              background :gray
              
              transform {
                translate 200, 200
                rotate((time.hour - 12)*30 - 90)
              }
            }
          }
        }
      }
    }
  }
end

Clock.launch
