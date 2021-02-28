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
          
          def location_parameter_names
            parameter_names
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
          
          def absolute_point_array
            if parent.is_a?(Shape)
              point_array.each_with_index.map do |coordinate, i|
                if i.even?
                  parent.absolute_x + coordinate
                else
                  parent.absolute_y + coordinate
                end
              end
            else
              point_array
            end
          end
          
          def absolute_x_array
            absolute_point_array.each_with_index.select {|pair| pair.last.even?}.map(&:first)
          end
          
          def absolute_y_array
            absolute_point_array.each_with_index.select {|pair| pair.last.odd?}.map(&:first)
          end
          
          def absolute_point_xy_array
            absolute_x_array.zip(absolute_y_array)
          end
          
          def bounds
            the_point_array = point_array
            if the_point_array != @bounds_point_array
              @bounds_point_array = point_array
              shape_bounds = geometry.getBounds2D
              @bounds = org.eclipse.swt.graphics.Rectangle.new(shape_bounds.x, shape_bounds.y, shape_bounds.width, shape_bounds.height)
            end
            @bounds
          end
          
          def size
            the_point_array = point_array
            if the_point_array != @size_point_array
              @size_point_array = point_array
              shape_bounds = geometry.getBounds2D
              @size = org.eclipse.swt.graphics.Point.new(shape_bounds.width, shape_bounds.height)
            end
            @size
          end
          
          def geometry
            the_point_array = point_array
            if the_point_array != @geometry_point_array
              @geometry_point_array = point_array
              @geometry = java.awt.Polygon.new(absolute_x_array.to_java(:int), absolute_y_array.to_java(:int), point_count)
            end
            @geometry
          end
          
          # Logical x coordinate relative to parent
          def x
            x_value = bounds.x
            x_value -= parent.absolute_x if parent.is_a?(Shape)
            x_value
          end
          
          # Logical y coordinate relative to parent
          def y
            y_value = bounds.y
            y_value -= parent.absolute_y if parent.is_a?(Shape)
            y_value
          end
          
          def width
            size.x
          end
          
          def height
            size.y
          end
          
          def contain?(x, y)
            geometry.contains(x, y)
          end

          def include?(x, y)
            comparison_lines = absolute_point_xy_array.zip(absolute_point_xy_array.rotate(1))
            comparison_lines.any? {|line| Line.include?(line.first.first, line.first.last, line.last.first, line.last.last, x, y)}
          end
                    
          def move_by(x_delta, y_delta)
            self.point_array = point_array.each_with_index.map {|coordinate, i| i.even? ? coordinate + x_delta : coordinate + y_delta}
          end
          
          def irregular?
            true
          end
          
        end
      end
    end
  end
end
