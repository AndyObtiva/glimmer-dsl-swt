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

module Glimmer
  module SWT
    module Custom
      # Represents a path to be drawn on a control/widget/canvas/display
      # That is because Shape is drawn on a parent as graphics and doesn't have an SWT widget for itself
      class Shape
        # Represents path segments like point, line, quad, and cubic curves
        # Shapes could mix in
        module PathSegment
          # Subclasses must override and implement to indicate method name to invoke on SWT Path object to add segment
          def path_segment_method_name
            nil
          end
          # Subclasses must override and implement to indicate args to pass when invoking SWT Path object method
          def path_segment_args
            []
          end
          # Subclasses may override to provide name of method to invoke for geometry object obtained from the Java AWT library java.awt.geom.Path2D.Double (e.g. curveTo vs cubicTo)
          def path_segment_geometry_method_name
            path_segment_method_name
          end
          # Subclasses must override and implement to indicate args to pass when invoking SWT Path object method
          def path_segment_geometry_args
            path_segment_args
          end
          # Subclasses must override to indicate otherwise
          def previous_point_connected?
            true
          end
          
          def dispose
            parent.post_dispose_content(self) if parent.is_a?(Path)
          end
          
          def first_path_segment?
            parent.path_segments.first == self
          end
          
          def previous_path_segment
            parent.path_segments[parent.path_segments.index(self) - 1] || self
          end
          
          def add_to_swt_path(swt_path)
            if @swt_path != swt_path
              @swt_path = swt_path
              the_path_segment_args = path_segment_args.dup
              if first_path_segment? && self.class != Path
                point = the_path_segment_args[0..1]
                @swt_path.moveTo(*point)
              elsif !previous_point_connected? && !is_a?(Point) && the_path_segment_args.count > 2
                point = the_path_segment_args.shift, the_path_segment_args.shift
                @swt_path.moveTo(*point)
              end
              @swt_path.send(path_segment_method_name, *the_path_segment_args)
            end
          end
        end
      end
    end
  end
end
