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
        class Polygon < Shape
          def parameter_names
            [:point_array]
          end
          
          def point_count
            point_array.count / 2
          end
          
          def [](index)
            index = 0 if index == point_count
            org.eclipse.swt.graphics.Point.new(point_array[index * 2], point_array[index * 2 + 1])
          end
          
          def x_array
            point_array.each_with_index.select {|pair| pair.last.even?}.map(&:first)
          end
          
          def y_array
            point_array.each_with_index.select {|pair| pair.last.odd?}.map(&:first)
          end
          
          def point_xy_array
            x_array.zip(y_array)
          end
          
          def include?(x, y)
            shape_geometry = java.awt.Polygon.new(x_array.to_java(:int), y_array.to_java(:int), point_count)
            shape_geometry.contains(x, y)
          end
          
          def move_by(x_delta, y_delta)
            self.point_array = point_array.each_with_index.map {|coordinate, i| i.even? ? coordinate + x_delta : coordinate + y_delta}
          end
        end
      end
    end
  end
end
