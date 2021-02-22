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

module Glimmer
  module SWT
    module Custom
      # Represents SWT drawable controls (widgets like canvas) and display
      module Drawable
        attr_accessor :requires_shape_disposal, :image_double_buffered
        alias requires_shape_disposal? requires_shape_disposal
        alias image_double_buffered? image_double_buffered
        
        include_package 'org.eclipse.swt.graphics'
      
        def shapes
          @shapes ||= []
        end
        
        def image_buffered_shapes
          @image_buffered_shapes ||= []
        end
        
        def shape_at_location(x, y)
          shapes.reverse.detect {|shape| shape.include?(x, y)}
        end
        
        def add_shape(shape)
          if !@image_double_buffered || shape.args.first == @image_proxy_buffer
            shapes << shape
          else
            image_buffered_shapes << shape
          end
        end
        
        def clear_shapes(dispose_images: true, dispose_patterns: true)
          # Optimize further by having a collection of disposable_shapes independent of shapes, which is much smaller and only has shapes that require disposal (shapes with patterns or image)
          shapes.dup.each {|s| s.dispose(dispose_images: dispose_images, dispose_patterns: dispose_patterns) } if requires_shape_disposal?
        end
        
        def paint_pixel_by_pixel(width = nil, height = nil, &each_pixel_color)
          if @image_double_buffered
            work = lambda do |paint_event|
              width ||= swt_drawable.bounds.width
              height ||= swt_drawable.bounds.height
              @image_proxy_buffer ||= ImageProxy.create_pixel_by_pixel(width, height, &each_pixel_color)
              @image_proxy_buffer.shape(self).paint(paint_event)
            end
          else
            work = lambda do |paint_event_or_image|
              the_gc = paint_event_or_image.gc
              current_foreground = nil
              width ||= swt_drawable.bounds.width
              height ||= swt_drawable.bounds.height
              height.times do |y|
                width.times do |x|
                  new_foreground = each_pixel_color.call(x, y)
                  new_foreground = Glimmer::SWT::ColorProxy.create(new_foreground, ensure_bounds: false) unless new_foreground.is_a?(ColorProxy) || new_foreground.is_a?(Color)
                  new_foreground = new_foreground.swt_color if new_foreground.is_a?(Glimmer::SWT::ColorProxy)
                  the_gc.foreground = current_foreground = new_foreground unless new_foreground == current_foreground
                  the_gc.draw_point x, y
                end
              end
            end
          end
          if respond_to?(:gc)
            work.call(self)
          else
            on_swt_paint(&work)
          end
        end
        
        def swt_drawable
          swt_drawable = nil
          if respond_to?(:swt_image)
            swt_drawable = swt_image
          elsif respond_to?(:swt_display)
            swt_drawable = swt_display
          elsif respond_to?(:swt_widget)
            swt_drawable = swt_widget
          end
          swt_drawable
        end
        
        def deregister_shape_painting
          @paint_listener_proxy&.deregister
        end
        
        def setup_shape_painting
          # TODO consider performance optimization relating to order of shape rendering (affecting only further shapes not previous ones)
          if @paint_listener_proxy.nil?
            shape_painter = lambda do |paint_event|
              shape_painting_work = lambda do |paint_event|
                paintable_shapes = @image_double_buffered ? image_buffered_shapes : shapes
                paintable_shapes.each do |shape|
                  shape.paint(paint_event)
                end
              end
              if @image_double_buffered
                if @image_proxy_buffer.nil?
                  swt_image = Image.new(DisplayProxy.instance.swt_display, bounds.width, bounds.height)
                  @image_proxy_buffer = ImageProxy.new(swt_image: swt_image)
                  shape_painting_work.call(@image_proxy_buffer)
                end
                @image_proxy_buffer.shape(self).paint(paint_event)
              else
                shape_painting_work.call(paint_event)
              end
            end
            
            # TODO consider making this logic polymorphic (image vs other)
            if respond_to?(:swt_image)
              shape_painter.call(self) # treat self as paint event since image has its own gc and doesn't do repaints (it's a one time deal for now though could be adjusted in the future.)
            else
              @paint_listener_proxy = on_swt_paint(&shape_painter)
            end
          else
            redraw if @finished_add_content && !is_disposed
          end
        end
        alias resetup_shape_painting setup_shape_painting
      end
      
    end
    
  end
  
end
