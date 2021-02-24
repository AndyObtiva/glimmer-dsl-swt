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

require 'glimmer/swt/custom/shape'
require 'glimmer/swt/swt_proxy'
require 'glimmer/swt/display_proxy'
require 'glimmer/swt/color_proxy'
require 'glimmer/swt/font_proxy'
require 'glimmer/swt/transform_proxy'

module Glimmer
  module SWT
    module Custom
      # Represents a shape (graphics) to be drawn on a control/widget/canvas/display
      # That is because Shape is drawn on a parent as graphics and doesn't have an SWT widget for itself
      class Shape
        class Line < Shape
          class << self
            def include?(x1, y1, x2, y2, x, y)
              distance1 = Math.sqrt((x - x1)**2 + (y - y1)**2)
              distance2 = Math.sqrt((x2 - x)**2 + (y2 - y)**2)
              distance = Math.sqrt((x2 - x1)**2 + (y2 - y1)**2)
              (distance1 + distance2).to_i == distance.to_i
            end
          end
        
          def parameter_names
            [:x1, :y1, :x2, :y2]
          end
          
          # Logical x coordinate. Always assumes the first point in the line to be the x coordinate.
          def x
            x1
          end
          
          # Logical y coordinate. Always assumes the first point in the line to be the y coordinate.
          def y
            y1
          end
          
          def absolute_x1
            if parent.is_a?(Shape)
              parent.absolute_x + x1
            else
              x1
            end
          end
          
          def absolute_y1
            if parent.is_a?(Shape)
              parent.absolute_y + y1
            else
              y1
            end
          end
          
          def absolute_x2
            if parent.is_a?(Shape)
              parent.absolute_x2 + x2
            else
              x2
            end
          end
          
          def absolute_y2
            if parent.is_a?(Shape)
              parent.absolute_y + y1
            else
              y2
            end
          end
          
          def include?(x, y)
            # TODO must account for line width
            Line.include?(absolute_x1, absolute_y1, absolute_x2, absolute_y2, x, y)
          end
          alias contain? include?
            
          def move_by(x_delta, y_delta)
            self.x1 += x_delta
            self.y1 += y_delta
            self.x2 += x_delta
            self.y2 += y_delta
          end
        end
      end
    end
  end
end
