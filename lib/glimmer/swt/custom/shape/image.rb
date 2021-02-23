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
        class Image < Shape
          def parameter_names
            if @args.to_a.size > 3
              image_part_parameter_names
            else
              image_whole_parameter_names
            end
          end
          
          def possible_parameter_names
            (image_part_parameter_names + image_whole_parameter_names).uniq
          end
          
          def image_part_parameter_names
            [:image, :src_x, :src_y, :src_width, :src_height, :dest_x, :dest_y, :dest_width, :dest_height]
          end
          
          def image_whole_parameter_names
            [:image, :x, :y]
          end
          
          def parameter_index(attribute_name)
            ####TODO refactor and improve this method through meta-programming (and share across other shapes)
            if image_part_parameter_names.map(&:to_s).include?(attribute_name.to_s)
              image_part_parameter_names.map(&:to_s).index(attribute_name.to_s)
            elsif image_whole_parameter_names.map(&:to_s).include?(attribute_name.to_s)
              image_whole_parameter_names.map(&:to_s).index(attribute_name.to_s)
            end
          end
          
          def effective_x
            dest_x || self.x
          end
          
          def effective_y
            dest_y || self.y
          end
          
          def effective_width
            dest_width || image.bounds.width
          end
          
          def effective_height
            dest_height || image.bounds.height
          end
          
          def include?(x, y)
            x.between?(effective_x, effective_x + effective_width) && y.between?(effective_y, effective_y + effective_height)
          end
          alias contain? include?
            
          def move_by(x_delta, y_delta)
            if dest_x
              self.dest_x += x_delta
              self.dest_y += y_delta
            else
              self.x += x_delta
              self.y += y_delta
            end
          end
        end
      end
    end
  end
end
