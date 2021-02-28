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
        class Quad < Path
          def parameter_names
            [:point_array]
          end
          
          def geometry
            if @point_array != @geometry_point_array
              @geometry_point_array = @point_array
              @geometry = Java::JavaAwtGeom::Path2D::Double.new
              @geometry.send(path_segment_geometry_method_name, *path_segment_geometry_args)
            end
            @geometry
          end
        
          def contain?(x, y)
            include?(x, y, filled: true)
          end
        
          # checks if drawn or filled rectangle includes the point denoted by x and y (if drawn, it only returns true if point lies on the edge)
          def include?(x, y, filled: nil)
            filled = filled? if filled.nil?
            makeshift_gc = org.eclipse.swt.graphics.GC.new(Glimmer::SWT::DisplayProxy.instance.swt_display)
            swt_path = org.eclipse.swt.graphics.Path.new(Glimmer::SWT::DisplayProxy.instance.swt_display)
            the_path_segment_args = path_segment_args.dup
            if previous_point_connected?
              the_previous_path_segment = previous_path_segment
              swt_path.moveTo(the_previous_path_segment.x, the_previous_path_segment.y)
            else
              swt_path.moveTo(the_path_segment_args.shift, the_path_segment_args.shift)
            end
            swt_path.quadTo(*the_path_segment_args)
            swt_path.contains(x.to_f, y.to_f, makeshift_gc, !filled)
          ensure
            swt_path.dispose
          end
            
          def move_by(x_delta, y_delta)
            the_point_array = @args.compact
            the_point_array = the_point_array.first if the_point_array.first.is_a?(Array)
            self.point_array = the_point_array.each_with_index.map {|coordinate, i| i.even? ? coordinate + x_delta : coordinate + y_delta}
          end
                              
          def path_segment_method_name
            'quadTo'
          end
          
          def path_segment_args
            # TODO make args auto-infer control points if previous_point_connected is true or if there is only a point_array with 1 point
            @args.to_a
          end
          
          def previous_point_connected?
            @args.compact.count <= 4 && !first_path_segment?
          end
          
          def eql?(other)
            point_array == (other && other.respond_to?(:point_array) && other.point_array)
          end
          alias == eql?
          
          def hash
            point_array.hash
          end
                    
        end
      end
    end
  end
end
