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
require 'glimmer/swt/display_proxy'

module Glimmer
  module SWT
    module Custom
      # Represents a path to be drawn on a control/widget/canvas/display
      # That is because Shape is drawn on a parent as graphics and doesn't have an SWT widget for itself
      class Shape
        class Path < Shape
          include PathSegment # a path may behave as a path segment in another path
          
          attr_accessor :flatness, :closed
          attr_reader :swt_path, :path_segments
        
          def initialize(parent, keyword, *args, &property_block)
            super
            @path_segments = []
            @uncalculated_path_segments = []
          end
          
          def parameter_names
            [:swt_path]
          end
          
          def add_shape(shape)
            if shape.is_a?(PathSegment)
              @path_segments << shape
              @uncalculated_path_segments << shape
            else
              super
            end
          end
          
          def contain?(x, y)
            makeshift_gc = org.eclipse.swt.graphics.GC.new(Glimmer::SWT::DisplayProxy.instance.swt_display)
            @swt_path.contains(x.to_f, y.to_f, makeshift_gc, false)
          end
          
          def contain?(x, y)
            include?(x, y, filled: true)
          end
        
          # checks if drawn or filled rectangle includes the point denoted by x and y (if drawn, it only returns true if point lies on the edge)
          def include?(x, y, filled: nil)
            filled = filled? if filled.nil?
            makeshift_gc = org.eclipse.swt.graphics.GC.new(Glimmer::SWT::DisplayProxy.instance.swt_display)
            @swt_path.contains(x.to_f, y.to_f, makeshift_gc, !filled)
          end
          
          def irregular?
            true
          end
          
          def post_dispose_content(path_segment)
            @path_segments.delete(path_segment)
            @uncalculated_path_segments = @path_segments.dup
            dispose
          end
          
          def dispose
            @swt_path&.dispose
            @swt_path = nil
            @args = []
            calculated_args_changed!(children: false)
            super
          end
          
          def calculated_args_changed!(children: true)
            super
          end
          
          def calculated_args
            new_swt_path = @swt_path.nil?
            @swt_path ||= org.eclipse.swt.graphics.Path.new(Glimmer::SWT::DisplayProxy.instance.swt_display)
            # TODO recreate @swt_path only if one of the children get disposed (must notify parent on dispose)
            @args = [@swt_path]
            @uncalculated_path_segments.each do |path_segment|
              path_segment.add_to_swt_path(@swt_path)
              @uncalculated_path_segments.delete(path_segment)
            end
            if new_swt_path
              @path_calculated_args = super
            else
              @path_calculated_args
            end
          rescue => e
            Glimmer::Config.logger.error {e.full_message}
            @args
          end
          
          def move_by(x_delta, y_delta)
            @path_segments.each {|path_segment| path_segment.move_by(x_delta, y_delta)}
          end
          
          def bounds
            if @path_segments != @bounds_path_segments
              @bounds_path_segments = @path_segments
              shape_bounds = geometry.getBounds2D
              @bounds = org.eclipse.swt.graphics.Rectangle.new(shape_bounds.x, shape_bounds.y, shape_bounds.width, shape_bounds.height)
            end
            @bounds
          end
          
          def size
            if @path_segments != @size_path_segments
              @size_path_segments = @path_segments
              shape_bounds = geometry.getBounds2D
              @size = org.eclipse.swt.graphics.Point.new(shape_bounds.width, shape_bounds.height)
            end
            @size
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
          
          def geometry
            if @path_segments != @geometry_path_segments
              @geometry_path_segments = @path_segments
              @geometry = Java::JavaAwtGeom::Path2D::Double.new
              @path_segments.each do |path_segment|
                @geometry.send(path_segment.path_segment_geometry_method_name, *path_segment.path_segment_geometry_args)
              end
            end
            @geometry
          end
                            
          def path_segment_method_name
            'addPath'
          end
                    
          def path_segment_args
            @args
          end
                            
          def path_segment_geometry_method_name
            'append'
          end
                    
          def path_segment_geometry_args
            # TODO consider supporting connected true instead of false (2nd arg)
            [geometry, false]
          end
          
          def eql?(other)
            geometry.equals(other && other.respond_to?(:geometry) && other.geometry)
          end
          alias == eql?
          
          def hash
            geometry.hashCode
          end
          
        end
      end
    end
  end
end
