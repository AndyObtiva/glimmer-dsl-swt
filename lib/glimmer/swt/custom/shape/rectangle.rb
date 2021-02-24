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
        class Rectangle < Shape
          def parameter_names
            if @args.to_a.size >= 6
              rectangle_round_parameter_names
            elsif @args.to_a.size == 5
              rectangle_gradient_parameter_names
            elsif @args.to_a.size == 1
              rectangle_rectangle_parameter_names
            else
              rectangle_parameter_names
            end
          end
          
          def possible_parameter_names
            # TODO refactor and improve this method through meta-programming (and share across other shapes)
            (rectangle_round_parameter_names + rectangle_gradient_parameter_names + rectangle_parameter_names + rectangle_rectangle_parameter_names).uniq
          end
          
          def rectangle_round_parameter_names
            [:x, :y, :width, :height, :arc_width, :arc_height]
          end
          
          def rectangle_gradient_parameter_names
            [:x, :y, :width, :height, :vertical]
          end
          
          def rectangle_parameter_names
            [:x, :y, :width, :height]
          end
          
          def rectangle_rectangle_parameter_names
            # this receives a Rectangle object
            [:rectangle]
          end
          
          def parameter_index(attribute_name)
            ####TODO refactor and improve this method through meta-programming (and share across other shapes)
            if rectangle_round_parameter_names.map(&:to_s).include?(attribute_name.to_s)
              rectangle_round_parameter_names.map(&:to_s).index(attribute_name.to_s)
            elsif rectangle_gradient_parameter_names.map(&:to_s).include?(attribute_name.to_s)
              rectangle_gradient_parameter_names.map(&:to_s).index(attribute_name.to_s)
            elsif rectangle_parameter_names.map(&:to_s).include?(attribute_name.to_s)
              rectangle_parameter_names.map(&:to_s).index(attribute_name.to_s)
            elsif rectangle_rectangle_parameter_names.map(&:to_s).include?(attribute_name.to_s)
              rectangle_rectangle_parameter_names.map(&:to_s).index(attribute_name.to_s)
            end
          end
          
          def point_xy_array
            [[x, y], [x + width, y], [x + width, y + height], [x, y + height]]
          end
          
          # checks if drawn or filled rectangle includes the point denoted by x and y (if drawn, it only returns true if point lies on the edge)
          def include?(x, y)
            if filled?
              contain?(x, y)
            else
              comparison_lines = point_xy_array.zip(point_xy_array.rotate(1))
              comparison_lines.any? {|line| Line.include?(line.first.first, line.first.last, line.last.first, line.last.last, x, y)}
            end
          end
          
        end
      end
    end
  end
end
