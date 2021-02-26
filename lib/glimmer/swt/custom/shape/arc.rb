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
        class Arc < Shape
          def parameter_names
            [:x, :y, :width, :height, :start_angle, :arc_angle]
          end
          
          def bounds
            shape_bounds = geometry.getBounds2D
            org.eclipse.swt.graphics.Rectangle.new(shape_bounds.x, shape_bounds.y, shape_bounds.width, shape_bounds.height)
          end
          
          def size
            shape_bounds = geometry.getBounds2D
            org.eclipse.swt.graphics.Point.new(shape_bounds.width, shape_bounds.height)
          end
          
          def geometry
            java.awt.geom.Arc2D::Double.new(self.absolute_x, self.absolute_y, calculated_width, calculated_height, start_angle, arc_angle, java.awt.geom.Arc2D::PIE)
          end
            
          # checks if shape contains the point denoted by x and y
          def contain?(x, y)
            geometry.contains(x, y)
          end
          
          def include?(x, y)
            if filled?
              contain?(x, y)
            else
              # give it some fuzz to allow a larger region around the drawn oval to accept including a point (helps with mouse clickability on a shape)
              outer_shape_geometry = java.awt.geom.Arc2D::Double.new(self.absolute_x, self.absolute_y, calculated_width + 3, calculated_height + 3, start_angle, arc_angle, java.awt.geom.Arc2D::PIE)
              inner_shape_geometry = java.awt.geom.Arc2D::Double.new(self.absolute_x, self.absolute_y, calculated_width - 3, calculated_height - 3, start_angle, arc_angle, java.awt.geom.Arc2D::PIE)
              outer_shape_geometry.contains(x, y) && !inner_shape_geometry.contains(x, y)
            end
          end
        end
      end
    end
  end
end
