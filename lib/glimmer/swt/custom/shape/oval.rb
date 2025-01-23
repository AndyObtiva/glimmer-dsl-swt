# Copyright (c) 2007-2025 Andy Maleh
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
        class Oval < Shape
          # checks if shape contains the point denoted by x and y
          def contain?(x, y)
            x, y = inverse_transform_point(x, y)
            shape_geometry = java.awt.geom.Ellipse2D::Double.new(self.absolute_x, self.absolute_y, calculated_width, calculated_height)
            shape_geometry.contains(x, y)
          end
          
          # checks if drawn or filled oval includes the point denoted by x and y (if drawn, it only returns true if point lies on the edge)
          def include?(x, y)
            if filled?
              contain?(x, y)
            else
              x, y = inverse_transform_point(x, y)
              # give it some fuzz to allow a larger region around the drawn oval to accept including a point (helps with mouse clickability on a shape)
              outer_shape_geometry = java.awt.geom.Ellipse2D::Double.new(self.absolute_x - 3, self.absolute_y - 3, calculated_width + 6, calculated_height + 6)
              inner_shape_geometry = java.awt.geom.Ellipse2D::Double.new(self.absolute_x + 3, self.absolute_y + 3, calculated_width - 6, calculated_height - 6)
              outer_shape_geometry.contains(x, y) && !inner_shape_geometry.contains(x, y)
            end
          end
        end
      end
    end
  end
end
