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

require 'glimmer/swt/properties'
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
        include Packages
        include Properties
        
        class << self
          def create(parent, keyword, *args, &property_block)
            potential_shape_class_name = keyword.to_s.camelcase(:upper).to_sym
            if constants.include?(potential_shape_class_name)
              const_get(potential_shape_class_name).new(parent, keyword, *args, &property_block)
            else
              new(parent, keyword, *args, &property_block)
            end
          end
        
          def valid?(parent, keyword, *args, &block)
            gc_instance_methods.include?(method_name(keyword, arg_options(args)))
          end
          
          def gc_instance_methods
            @gc_instance_methods ||= org.eclipse.swt.graphics.GC.instance_methods.map(&:to_s)
          end
          
          def keywords
            @keywords ||= gc_instance_methods.select do |method_name|
              !method_name.end_with?('=') && (method_name.start_with?('draw_') || method_name.start_with?('fill_'))
            end.reject do |method_name|
              gc_instance_methods.include?("#{method_name}=") || gc_instance_methods.include?("set_#{method_name}")
            end.map do |method_name|
              method_name.gsub(/(draw|fill|gradient|round)_/, '')
            end.uniq.compact.to_a
          end
          
          def arg_options(args, extract: false)
            arg_options_method = extract ? :pop : :last
            options = args.send(arg_options_method) if args.last.is_a?(Hash)
            options.nil? ? {} : options.symbolize_keys
          end
          
          def method_name(keyword, method_arg_options)
            keyword = keyword.to_s
            method_arg_options = method_arg_options.select {|key, value| %w[fill gradient round].include?(key.to_s)}
            unless flyweight_method_names.keys.include?([keyword, method_arg_options])
              gradient = 'Gradient' if method_arg_options[:gradient]
              round = 'Round' if method_arg_options[:round]
              gc_instance_method_name_prefix = !['polyline', 'point', 'image', 'focus'].include?(keyword) && (method_arg_options[:fill] || method_arg_options[:gradient]) ? 'fill' : 'draw'
              flyweight_method_names[[keyword, method_arg_options]] = "#{gc_instance_method_name_prefix}#{gradient}#{round}#{keyword.capitalize}"
            end
            flyweight_method_names[[keyword, method_arg_options]]
          end
          
          def flyweight_method_names
            @flyweight_method_names ||= {}
          end
          
          def pattern(*args)
            found_pattern = flyweight_patterns[args]
            if found_pattern.nil? || found_pattern.is_disposed
              found_pattern = flyweight_patterns[args] = org.eclipse.swt.graphics.Pattern.new(*args)
            end
            found_pattern
          end
          
          def flyweight_patterns
            @flyweight_patterns ||= {}
          end
        end
        
        attr_reader :drawable, :parent, :name, :args, :options, :shapes
        attr_accessor :x_delta, :y_delta
        
        def initialize(parent, keyword, *args, &property_block)
          @parent = parent
          @drawable = @parent.is_a?(Drawable) ? @parent : @parent.drawable
          @name = keyword
          @options = self.class.arg_options(args, extract: true)
          @method_name = self.class.method_name(keyword, @options)
          @args = args
          @properties = {}
          @shapes = [] # nested shapes
          @x_delta = 0
          @y_delta = 0
          @options.reject {|key, value| %w[fill gradient round].include?(key.to_s)}.each do |property, property_args|
            @properties[property] = property_args
          end
          @parent.add_shape(self)
          post_add_content if property_block.nil?
        end
        
        def add_shape(shape)
          @shapes << shape
        end
        
        def draw?
          !fill?
        end
        alias drawn? draw?
        
        def fill?
          @options[:fill]
        end
        alias filled? fill?
        
        def gradient?
          @options[:gradient]
        end
        
        def round?
          @options[:round]
        end
        
        # subclasses (like polygon) may override to indicate if a point x,y coordinates falls inside the shape
        # some shapes may choose to provide a fuzz factor to make usage of this method for mouse clicking more user friendly
        def contain?(x, y)
          # assume a rectangular filled shape by default (works for several shapes like image, text, and focus)
          if respond_to?(:x) && respond_to?(:y) && respond_to?(:width) && respond_to?(:height) && self.x && self.y && width && height
            x.between?(self.absolute_x, self.absolute_x + width) && y.between?(self.absolute_y, self.absolute_y + height)
          else
            false # subclasses must provide implementation
          end
        end
        
        # subclasses (like polygon) may override to indicate if a point x,y coordinates falls on the edge of a drawn shape or inside a filled shape
        # some shapes may choose to provide a fuzz factor to make usage of this method for mouse clicking more user friendly
        def include?(x, y)
          # assume a rectangular shape by default
          if respond_to?(:x) && respond_to?(:y) && respond_to?(:width) && respond_to?(:height)
            contain?(x, y)
          else
            false # subclasses must provide implementation
          end
        end
        
        # moves by x delta and y delta. Subclasses must implement
        # provdies a default implementation that assumes moving x and y is sufficient by default (not for polygons though, which must override)
        def move_by(x_delta, y_delta)
          if respond_to?(:x) && respond_to?(:y) && x && y
            if default_x?
              self.x_delta += x_delta
            else
              self.x += x_delta
            end
            if default_y?
              self.y_delta += y_delta
            else
              self.y += y_delta
            end
          end
        end
        
        def change_x(x_delta)
          if default_x?
            self.x_delta += x_delta
          else
            self.x += x_delta
          end
        end
        
        def change_y(x_delta)
          if default_y?
            self.y_delta += y_delta
          else
            self.y += y_delta
          end
        end
        
        def has_some_background?
          @properties.keys.map(&:to_s).include?('background') || @properties.keys.map(&:to_s).include?('background_pattern')
        end
        
        def has_some_foreground?
          @properties.keys.map(&:to_s).include?('foreground') || @properties.keys.map(&:to_s).include?('foreground_pattern')
        end
        
        def post_add_content
          unless @content_added
            amend_method_name_options_based_on_properties!
            @drawable.setup_shape_painting unless @drawable.is_a?(ImageProxy)
            @content_added = true
          end
        end
        
        def apply_property_arg_conversions(method_name, property, args)
          args = args.dup
          the_java_method = org.eclipse.swt.graphics.GC.java_class.declared_instance_methods.detect {|m| m.name == method_name}
          if the_java_method.parameter_types.first == Color.java_class && args.first.is_a?(RGB)
            args[0] = [args[0].red, args[0].green, args[0].blue]
          end
          if ['setBackground', 'setForeground'].include?(method_name.to_s) && args.first.is_a?(Array)
            args[0] = ColorProxy.new(args[0])
          end
          if args.first.is_a?(Symbol) || args.first.is_a?(::String)
            if the_java_method.parameter_types.first == Color.java_class
              args[0] = ColorProxy.new(args[0])
            end
            if the_java_method.parameter_types.first == Java::int.java_class
              args[0] = SWTProxy.constant(args[0])
            end
          end
          if args.first.is_a?(ColorProxy)
            args[0] = args[0].swt_color
          end
          if (args.first.is_a?(Hash) || args.first.is_a?(FontData)) && the_java_method.parameter_types.first == Font.java_class
            args[0] = FontProxy.new(args[0])
          end
          if args.first.is_a?(FontProxy)
            args[0] = args[0].swt_font
          end
          if args.first.is_a?(TransformProxy)
            args[0] = args[0].swt_transform
          end
          if ['setBackgroundPattern', 'setForegroundPattern'].include?(method_name.to_s)
            @drawable.requires_shape_disposal = true
            args = args.first if args.first.is_a?(Array)
            args.each_with_index do |arg, i|
              arg = ColorProxy.new(arg.red, arg.green, arg.blue) if arg.is_a?(RGB)
              arg = ColorProxy.new(arg) if arg.is_a?(Symbol) || arg.is_a?(::String)
              arg = arg.swt_color if arg.is_a?(ColorProxy)
              args[i] = arg
            end
            @pattern_args ||= {}
            pattern_type = method_name.to_s.match(/set(.+)Pattern/)[1]
            if args.first.is_a?(Pattern)
              new_args = @pattern_args[pattern_type]
            else
              new_args = args.first.is_a?(Display) ? args : ([DisplayProxy.instance.swt_display] + args)
              @pattern_args[pattern_type] = new_args.dup
            end
            args[0] = pattern(*new_args, type: pattern_type)
            args[1..-1] = []
          end
          args
        end
        
        def apply_shape_arg_conversions!
          if @args.size > 1 && (['polygon', 'polyline'].include?(@name))
            @args[0] = @args.dup
            @args[1..-1] = []
          end
          if @name == 'image'
            if @args.first.is_a?(::String)
              @args[0] = ImageProxy.new(@args[0])
            end
            if @args.first.is_a?(ImageProxy)
              @image = @args[0] = @args[0].swt_image
            end
            if @args.first.nil?
              @image = nil
            end
          end
          if @name == 'text'
            if @args[3].is_a?(Symbol) || @args[3].is_a?(::String)
              @args[3] = [@args[3]]
            end
            if @args[3].is_a?(Array)
              if @args[3].size == 1 && @args[3].first.is_a?(Array)
                @args[3] = @args[3].first
              end
              @args[3] = SWTProxy[*@args[3]]
            end
          end
        end
        
        def apply_shape_arg_defaults!
          if @name.include?('rectangle') && round? && @args.size.between?(4, 5)
            (6 - @args.size).times {@args << 60}
          elsif @name.include?('rectangle') && gradient? && @args.size == 4
            @args << true # vertical is true by default
          elsif (@name.include?('text') || @name.include?('string')) && !@properties.keys.map(&:to_s).include?('background') && @args.size == 3
            @args << true # is_transparent is true by default
          end
          if @name.include?('image')
            @drawable.requires_shape_disposal = true
          end
          self.x = :default if current_parameter_name?(:x) && x.nil?
          self.y = :default if current_parameter_name?(:y) && y.nil?
          self.dest_x = :default if current_parameter_name?(:dest_x) && dest_x.nil?
          self.dest_y = :default if current_parameter_name?(:dest_y) && dest_y.nil?
        end
                
        # Tolerates shape extra args added by user by mistake
        # (e.g. happens when switching from round rectangle to a standard one without removing all extra args)
        def tolerate_shape_extra_args!
          the_java_method_arg_count = org.eclipse.swt.graphics.GC.java_class.declared_instance_methods.select do |m|
            m.name == @method_name.camelcase(:lower)
          end.map(&:parameter_types).map(&:size).max
          if the_java_method_arg_count && @args.to_a.size > the_java_method_arg_count
            @args[the_java_method_arg_count..-1] = []
          end
        end
        
        def amend_method_name_options_based_on_properties!
          return if @name == 'point'
          if @name != 'text' && @name != 'string' && has_some_background? && !has_some_foreground?
            @options[:fill] = true
          elsif !has_some_background? && has_some_foreground?
            @options[:fill] = false
          elsif @name == 'rectangle' && has_some_background? && has_some_foreground?
            @options[:fill] = true
            @options[:gradient] = true
          end
          if @name == 'rectangle' && @args.size > 4 && @args.last.is_a?(Numeric)
            @options[:round] = true
          end
          @method_name = self.class.method_name(@name, @options)
        end
        
        # parameter names for arguments to pass to SWT GC.xyz method for rendering shape (e.g. draw_image(image, x, y) yields :image, :x, :y parameter names)
        def parameter_names
          []
        end
        
        def possible_parameter_names
          parameter_names
        end
        
        def parameter_name?(attribute_name)
          possible_parameter_names.map(&:to_s).include?(ruby_attribute_getter(attribute_name))
        end
        
        def current_parameter_name?(attribute_name)
          parameter_names.map(&:to_s).include?(ruby_attribute_getter(attribute_name))
        end
        
        def parameter_index(attribute_name)
          parameter_names.map(&:to_s).index(attribute_name.to_s)
        end
        
        def set_parameter_attribute(attribute_name, *args)
          @args[parameter_index(ruby_attribute_getter(attribute_name))] = args.size == 1 ? args.first : args
        end
        
        def has_attribute?(attribute_name, *args)
          self.class.gc_instance_methods.include?(attribute_setter(attribute_name)) or
            parameter_name?(attribute_name)
        end
  
        def set_attribute(attribute_name, *args)
          if parameter_name?(attribute_name)
            set_parameter_attribute(attribute_name, *args)
          else
            @properties[ruby_attribute_getter(attribute_name)] = args
          end
          if @content_added && !@drawable.is_disposed
            @calculated_paint_args = false
            @drawable.redraw
          end
        end
        
        def get_attribute(attribute_name)
          if parameter_name?(attribute_name)
            arg_index = parameter_index(attribute_name)
            @args[arg_index] if arg_index
          else
            @properties.symbolize_keys[attribute_name.to_s.to_sym]
          end
        end
        
        def method_missing(method_name, *args, &block)
          if method_name.to_s.end_with?('=')
            set_attribute(method_name, *args)
          elsif has_attribute?(method_name)
            get_attribute(method_name)
          else
            super
          end
        end
        
        def respond_to?(method_name, *args, &block)
          if has_attribute?(method_name)
            true
          else
            super
          end
        end
        
        def pattern(*args, type: nil)
          instance_variable_name = "@#{type}_pattern"
          the_pattern = instance_variable_get(instance_variable_name)
          if the_pattern.nil? || the_pattern.is_disposed
            the_pattern = self.class.pattern(*args)
          end
          the_pattern
        end
        
        def pattern_args(type: nil)
          @pattern_args && @pattern_args[type.to_s.capitalize]
        end
        
        def background_pattern_args
          pattern_args(type: 'background')
        end
        
        def foreground_pattern_args
          pattern_args(type: 'foreground')
        end
        
        def dispose(dispose_images: true, dispose_patterns: true)
          if dispose_patterns
            @background_pattern&.dispose
            @background_pattern = nil
            @foreground_pattern&.dispose
            @foreground_pattern = nil
          end
          if dispose_images
            @image&.dispose
            @image = nil
          end
          @parent.shapes.delete(self)
        end
                
        def paint(paint_event)
          calculate_paint_args!
          @properties.each do |property, args|
            method_name = attribute_setter(property)
            # TODO consider optimization of not setting a background/foreground/font if it didn't change from last shape
            paint_event.gc.send(method_name, *args)
            if property == 'transform' && args.first.is_a?(TransformProxy)
              args.first.swt_transform.dispose
            end
          end
          self.extent = paint_event.gc.send("#{@name}Extent", *(([string, flags] if respond_to?(:flags)).compact)) if ['text', 'string'].include?(@name)
          paint_event.gc.send(@method_name, *absolute_args)
          paint_children(paint_event)
        rescue => e
          Glimmer::Config.logger.error {"Error encountered in painting shape: #{self.inspect}"}
          Glimmer::Config.logger.error {e.full_message}
        end
        
        def paint_children(paint_event)
          shapes.to_a.each do |shape|
            shape.paint(paint_event)
          end
        end
        
        def expanded_shapes
          if shapes.to_a.any?
            shapes.map do |shape|
              [shape] + shape.expanded_shapes
            end.flatten
          else
            []
          end
        end
                
        # args translated to absolute coordinates
        def absolute_args
          original_x = nil
          original_y = nil
          if default_x?
            original_x = x
            self.x = default_x
          end
          if default_y?
            original_y = y
            self.y = default_y
          end
          move_by(x_delta, y_delta)
          if parent.is_a?(Shape)
            move_by(parent.absolute_x, parent.absolute_y)
            calculated_absolute_args = @args.clone
            move_by(-1*parent.absolute_x, -1*parent.absolute_y)
          else
            calculated_absolute_args = @args.clone
          end
          move_by(-1*x_delta, -1*y_delta)
          if original_x
            self.x = original_x
          end
          if original_y
            self.y = original_y
          end
          calculated_absolute_args
        end
        
        def default_x?
          current_parameter_name?('x') && (x.nil? || x.to_s == 'default')
        end
        
        def default_y?
          current_parameter_name?('y') && (y.nil? || y.to_s == 'default')
        end
        
        def default_x
          if respond_to?(:width) && width && parent.respond_to?(:width) && parent.width
            (parent.width - width) / 2
          else
            0
          end
        end
        
        def default_y
          if respond_to?(:height) && height && parent.respond_to?(:height) && parent.height
            (parent.height - height) / 2
          else
            0
          end
        end
        
        def absolute_x
          x = default_x? ? default_x : self.x
          x += x_delta
          if parent.is_a?(Shape)
            parent.absolute_x + x
          else
            x
          end
        end
        
        def absolute_y
          y = default_y? ? default_y : self.y
          y += y_delta
          if parent.is_a?(Shape)
            parent.absolute_y + y
          else
            y
          end
        end
        
        def calculate_paint_args!
          unless @calculated_paint_args
            if @name == 'pixel'
              @name = 'point'
              # optimized performance calculation for pixel points
              if !@properties[:foreground].is_a?(Color)
                if @properties[:foreground].is_a?(Array)
                  @properties[:foreground] = ColorProxy.new(@properties[:foreground], ensure_bounds: false)
                end
                if @properties[:foreground].is_a?(Symbol) || @properties[:foreground].is_a?(::String)
                 @properties[:foreground] = ColorProxy.new(@properties[:foreground], ensure_bounds: false)
                end
                if @properties[:foreground].is_a?(ColorProxy)
                  @properties[:foreground] = @properties[:foreground].swt_color
                end
              end
            else
              @properties['background'] = [@drawable.background] if fill? && !has_some_background?
              @properties['foreground'] = [@drawable.foreground] if @drawable.respond_to?(:foreground) && draw? && !has_some_foreground?
              # TODO regarding alpha, make sure to reset it to parent stored alpha once we allow setting shape properties on parents directly without shapes
              @properties['alpha'] ||= [255]
              @properties['font'] = [@drawable.font] if @drawable.respond_to?(:font) && draw? && !@properties.keys.map(&:to_s).include?('font')
              # TODO regarding transform, make sure to reset it to parent stored alpha once we allow setting shape properties on parents directly without shapes
              # Also do that with all future-added properties
              @properties['transform'] = [nil] if @drawable.respond_to?(:transform) && !@properties.keys.map(&:to_s).include?('transform')
              @properties.each do |property, args|
                method_name = attribute_setter(property)
                converted_args = apply_property_arg_conversions(method_name, property, args)
                @properties[property] = converted_args
              end
              apply_shape_arg_conversions!
              apply_shape_arg_defaults!
              tolerate_shape_extra_args!
              @calculated_paint_args = true
            end
          end
        end
    
      end
      
    end
    
  end
  
end

Dir[File.expand_path(File.join(__dir__, 'shape', '**', '*.rb'))].each {|shape_file| require(shape_file)}
