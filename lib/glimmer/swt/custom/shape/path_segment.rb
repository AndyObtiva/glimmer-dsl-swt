# Copyright (c) 2007-2022 Andy Maleh
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
      class Shape
        # Represents path segments like point, line, quad, and cubic curves
        # Shapes could mix in
        module PathSegment
          def root_path
            current_parent = parent
            until current_parent.class == Path && !current_parent.parent.is_a?(Path)
              current_parent = current_parent.parent
              return current_parent if current_parent.nil?
            end
            current_parent
          end
          def path
            current_parent = parent
            until current_parent.class == Path
              current_parent = current_parent.parent
              return current_parent if current_parent.nil?
            end
            current_parent
          end
          # this is needed to indicate if a shape is part of a path or not (e.g. line and point could be either)
          def part_of_path?
            !!root_path
          end
          # Subclasses must override and implement to indicate method name to invoke on SWT Path object to add segment
          def path_segment_method_name
            nil
          end
          # Subclasses must override and implement to indicate args to pass when invoking SWT Path object method
          def path_segment_args
            []
          end
          # Subclasses must override to indicate expected complete count of args when previous point is NOT connected (e.g. 4 for line, 6 for quad, 8 for cubic)
          def default_path_segment_arg_count
          end
          # Subclasses must override to indicate expected count of args when previous point IS connected (e.g. 2 for line, 4 for quad, 6 for cubic)
          def default_connected_path_segment_arg_count
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
          
          def dispose(dispose_images: true, dispose_patterns: true, redraw: true)
            Glimmer::SWT::DisplayProxy.instance.auto_exec do
              # including classes could override to dispose of resources first
              # afterwards, parent removes from its path segments with post_dispose_content
              parent.post_dispose_content(self) if parent.is_a?(Path)
              if part_of_path?
                drawable.redraw if redraw && !drawable.is_a?(ImageProxy)
              else
                super(dispose_images: dispose_images, dispose_patterns: dispose_patterns, redraw: redraw)
              end
            end
          end
          
          def first_path_segment?
            parent.path_segments.first == self
          end
          
          def previous_path_segment
            parent.path_segments[parent.path_segments.index(self) - 1] || self
          end
          
          def add_to_swt_path(swt_path)
            the_path_segment_args = path_segment_args.dup
            the_path_segment_args = the_path_segment_args.first if the_path_segment_args.size == 1 && the_path_segment_args.first.is_a?(Array)
            if !is_a?(Point) && self.class != Path
              if !previous_point_connected?
                if the_path_segment_args.count == default_path_segment_arg_count
                  point = the_path_segment_args.shift, the_path_segment_args.shift
                  swt_path.moveTo(*point)
                elsif first_path_segment?
                  point = the_path_segment_args[0..1]
                  swt_path.moveTo(*point)
                end
              end
            end
            swt_path.send(path_segment_method_name, *the_path_segment_args)
          end
          
          def add_to_geometry(geometry)
            the_path_segment_geometry_args = path_segment_geometry_args.dup
            if !is_a?(Point) && self.class != Path
              if !previous_point_connected?
                if the_path_segment_geometry_args.count == default_path_segment_arg_count
                  point = the_path_segment_geometry_args.shift, the_path_segment_geometry_args.shift
                  geometry.moveTo(point[0], point[1])
                elsif first_path_segment?
                  point = the_path_segment_geometry_args[0..1]
                  geometry.moveTo(point[0], point[1])
                end
              end
            end
            geometry.send(path_segment_geometry_method_name, *the_path_segment_geometry_args)
          end
                  
        end
      end
    end
  end
end
