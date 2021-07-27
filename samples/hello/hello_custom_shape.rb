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

# Creates a class-based custom shape representing the `stick_figure` keyword by convention
class StickFigure
  include Glimmer::UI::CustomShape
  
  options :x, :y, :width, :height
  
  before_body {
    @head_width = width*0.2
    @head_height = height*0.2
    @trunk_height = height*0.4
    @extremity_length = height*0.4
  }
  
  body {
    shape(x + @head_width/2.0 + @extremity_length, y) {
      oval(0, 0, @head_width, @head_height)
      line(@head_width/2.0, @head_height, @head_width/2.0, @head_height + @trunk_height)
      line(@head_width/2.0, @head_height + @trunk_height, @head_width/2.0 + @extremity_length, @head_height + @trunk_height + @extremity_length)
      line(@head_width/2.0, @head_height + @trunk_height, @head_width/2.0 - @extremity_length, @head_height + @trunk_height + @extremity_length)
      line(@head_width/2.0, @head_height*2, @head_width/2.0 + @extremity_length, @head_height + @trunk_height - @extremity_length)
      line(@head_width/2.0, @head_height*2, @head_width/2.0 - @extremity_length, @head_height + @trunk_height - @extremity_length)
    }
  }
end

class HelloCustomShape
  include Glimmer::UI::CustomShell
  
  WIDTH = 220
  HEIGHT = 235
  
  body {
    shell {
      text 'Hello, Custom Shape!'
      minimum_size WIDTH, HEIGHT
    
      @canvas = canvas {
        background :white
        
        15.times { |n|
          x_location = (rand*WIDTH/2).to_i%WIDTH + (rand*15).to_i
          y_location = (rand*HEIGHT/2).to_i%HEIGHT + (rand*15).to_i
          foreground_color = rgb(rand*255, rand*255, rand*255)
          
          a_stick_figure = stick_figure(x: x_location, y: y_location, width: 35+n*2, height: 35+n*2) {
            foreground foreground_color
            drag_and_move true
            
            # on mouse click, change color
            on_mouse_up do
              a_stick_figure.foreground = rgb(rand*255, rand*255, rand*255)
            end
          }
        }
      }
    }
  }
end

HelloCustomShape.launch
        
