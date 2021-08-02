# Copyright (c) 2007-2021 Andy Maleh
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
require 'glimmer/swt/custom/shape/path_segment'
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
          include PathSegment
          
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
          
          def location_parameter_names
            parameter_names
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
            java.awt.geom.Line2D::Double.new(absolute_x1, absolute_y1, absolute_x2, absolute_y2)
          end
          
          # Logical x coordinate relative to parent
          def x
            x_value = bounds.x
            x_value -= parent.absolute_x if parent.is_a?(Shape) && parent.class != Shape
            x_value
          end
          
          # Logical y coordinate relative to parent
          def y
            y_value = bounds.y
            y_value -= parent.absolute_y if parent.is_a?(Shape) && parent.class != Shape
            y_value
          end
          
          def width
            size.x
          end
          
          def height
            size.y
          end
          
          def absolute_x1
            if parent.is_a?(Shape) && parent.class != Shape
              parent.absolute_x + x1
            else
              x1
            end
          end
          
          def absolute_y1
            if parent.is_a?(Shape) && parent.class != Shape
              parent.absolute_y + y1
            else
              y1
            end
          end
          
          def absolute_x2
            if parent.is_a?(Shape) && parent.class != Shape
              parent.absolute_x + x2.to_f
            else
              x2
            end
          end
          
          def absolute_y2
            if parent.is_a?(Shape) && parent.class != Shape
              parent.absolute_y + y2.to_f
            else
              y2
            end
          end
          
          def include?(x, y)
            x, y = inverse_transform_point(x, y)
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
          
          def irregular?
            true
          end
                    
          def path_segment_method_name
            'lineTo'
          end
          
          def path_segment_args
            # TODO make args auto-infer first point if previous_point_connected is true or if there is only x1,y1 or x2,y2 (but not both), or if there is an x, y, or if there is a point_array with 1 point
            @args
          end
          
          def default_path_segment_arg_count
            4
          end
          
          def default_connected_path_segment_arg_count
            2
          end
          
          def path_segment_geometry_args
            # TODO make args auto-infer first point if previous_point_connected is true or if there is only x1,y1 or x2,y2 (but not both), or if there is an x, y, or if there is a point_array with 1 point
            @args
          end
          
          def previous_point_connected?
            @args.compact.count == 2 && !first_path_segment?
          end
          
          def eql?(other)
            other.is_a?(Line) &&
              x1 == (other && other.respond_to?(:x1) && other.x1) &&
              y1 == (other && other.respond_to?(:y1) && other.y1) &&
              x2 == (other && other.respond_to?(:x2) && other.x2) &&
              y2 == (other && other.respond_to?(:y2) && other.y2)
          end
          alias == eql?
          
          def hash
            [x1, y1, x2, y2].hash
          end
                    
        end
      end
    end
  end
end
