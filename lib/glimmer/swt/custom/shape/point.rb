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
        class Point < Shape
          include PathSegment
          
          def parameter_names
            [:x, :y]
          end
          
          def width
            1
          end
          
          def height
            1
          end
          
          def include?(x, y)
            x, y = inverse_transform_point(x, y)
            # give it some fuzz (helps makes mouse clicking easier)
            x.to_i.between?(self.absolute_x.to_i - 2, self.absolute_x.to_i + 2) && y.to_i.between?(self.absolute_y.to_i - 2, self.absolute_y.to_i + 2)
          end
          
          def contain?(x, y)
            include?(x, y)
          end
          
          def bounds_contain?(x, y)
            include?(x, y)
          end
          
          def path_segment_method_name
            'addRectangle'
          end
                    
          def path_segment_args
            @args + [1, 1]
          end
          
          def path_segment_geometry_method_name
            'moveTo'
          end
                    
          def path_segment_geometry_args
            @args
          end
          
          def previous_point_connected?
            false
          end
          
          def eql?(other)
            other.is_a?(Point) && x == (other && other.respond_to?(:x) && other.x) && y == (other && other.respond_to?(:y) && other.y)
          end
          alias == eql?
          
          def hash
            [x, y].hash
          end
          
        end
      end
    end
  end
end
