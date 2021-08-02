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

class Java::OrgEclipseSwtGraphics::GC
  def setLineDashOffset(value)
    lineMiterLimit = getLineAttributes&.miterLimit || 999_999
    setLineAttributes(Java::OrgEclipseSwtGraphics::LineAttributes.new(getLineWidth, getLineCap, getLineJoin, getLineStyle, getLineDash.map(&:to_f).to_java(:float), value, lineMiterLimit))
  end
  alias set_line_dash_offset setLineDashOffset
  alias line_dash_offset= setLineDashOffset
  
  def getLineDashOffset
    getLineAttributes&.dashOffset
  end
  alias get_line_dash_offset getLineDashOffset
  alias line_dash_offset getLineDashOffset
  
  def setLineMiterLimit(value)
    lineDashOffset = getLineAttributes&.dashOffset || 0
    setLineAttributes(Java::OrgEclipseSwtGraphics::LineAttributes.new(getLineWidth, getLineCap, getLineJoin, getLineStyle, getLineDash.map(&:to_f).to_java(:float), lineDashOffset, value))
  end
  alias set_line_miter_limit setLineMiterLimit
  alias line_miter_limit= setLineMiterLimit
  
  def getLineMiterLimit
    getLineAttributes&.miterLimit
  end
  alias get_line_miter_limit getLineMiterLimit
  alias line_miter_limit getLineMiterLimit
end

module Glimmer
  module SWT
    module Custom
      # Represents a shape (graphics) to be drawn on a control/widget/canvas/display
      # That is because Shape is drawn on a parent as graphics and doesn't have an SWT widget for itself
      class Shape
        include Properties
        
        DropEvent = Struct.new(:doit, :x, :y, :dragged_shape, :dragged_shape_original_x, :dragged_shape_original_y, :dragging_x, :dragging_y, :drop_shapes, keyword_init: true)
        
        class << self
          attr_accessor :dragging, :dragging_x, :dragging_y, :dragged_shape, :dragged_shape_original_x, :dragged_shape_original_y
          alias dragging? dragging
        
          def create(parent, keyword, *args, &property_block)
            potential_shape_class_name = keyword.to_s.camelcase(:upper).to_sym
            if constants.include?(potential_shape_class_name)
              const_get(potential_shape_class_name).new(parent, keyword, *args, &property_block)
            else
              new(parent, keyword, *args, &property_block)
            end
          end
        
          def valid?(parent, keyword, *args, &block)
            return true if keyword.to_s == 'shape'
            gc_instance_methods.include?(method_name(keyword, arg_options(args))) ||
              constants.include?(keyword.to_s.camelcase(:upper).to_sym)
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
            options = args.send(arg_options_method).symbolize_keys if args.last.is_a?(Hash)
            # normalize :filled option as an alias to :fill
#             options[:fill] = options.delete(:filled) if options&.keys&.include?(:filled)
            options.nil? ? {} : options
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
          
          # shapes that have defined on_drop expecting to received a dragged shape
          def drop_shapes
            @drop_shapes ||= []
          end
        end
        
        attr_reader :drawable, :parent, :name, :args, :options, :shapes, :properties
        attr_accessor :extent
        
        def initialize(parent, keyword, *args, &property_block)
          @parent = parent
          @drawable = @parent.is_a?(Drawable) ? @parent : @parent.drawable
          @name = keyword
          @options = self.class.arg_options(args, extract: true)
          @method_name = self.class.method_name(keyword, @options) unless keyword.to_s == 'shape'
          @args = args
          @properties = {}
          @shapes = [] # nested shapes
          @options.reject {|key, value| %w[fill gradient round].include?(key.to_s)}.each do |property, property_args|
            @properties[property] = property_args
          end
          @parent.add_shape(self)
          post_add_content if property_block.nil?
        end
        
        def add_shape(shape)
          @shapes << shape
          calculated_args_changed_for_defaults!
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
        
        # The bounding box top-left x, y, width, height in absolute positioning
        def bounds
          bounds_dependencies = [absolute_x, absolute_y, calculated_width, calculated_height]
          if bounds_dependencies != @bounds_dependencies
            # avoid repeating calculations
            absolute_x, absolute_y, calculated_width, calculated_height = @bounds_dependencies = bounds_dependencies
            @bounds = org.eclipse.swt.graphics.Rectangle.new(absolute_x, absolute_y, calculated_width, calculated_height)
          end
          @bounds
        end
        
        # The bounding box top-left x and y
        def location
          org.eclipse.swt.graphics.Point.new(bounds.x, bounds.y)
        end
        
        # The bounding box width and height (as a Point object with x being width and y being height)
        def size
          size_dependencies = [calculated_width, calculated_height]
          if size_dependencies != @size_dependencies
            # avoid repeating calculations
            calculated_width, calculated_height = @size_dependencies = size_dependencies
            @size = org.eclipse.swt.graphics.Point.new(calculated_width, calculated_height)
          end
          @size
        end
        
        def extent
          @extent || size
        end
        
        # Returns if shape contains a point
        # Subclasses (like polygon) may override to indicate if a point x,y coordinates falls inside the shape
        # some shapes may choose to provide a fuzz factor to make usage of this method for mouse clicking more user friendly
        def contain?(x, y)
          x, y = inverse_transform_point(x, y)
          # assume a rectangular filled shape by default (works for several shapes like image, text, and focus)
          x.between?(self.absolute_x, self.absolute_x + calculated_width.to_f) && y.between?(self.absolute_y, self.absolute_y + calculated_height.to_f)
        end
        
        # Returns if shape includes a point. When the shape is filled, this is the same as contain. When the shape is drawn, it only returns true if the point lies on the edge (boundary/border)
        # Subclasses (like polygon) may override to indicate if a point x,y coordinates falls on the edge of a drawn shape or inside a filled shape
        # some shapes may choose to provide a fuzz factor to make usage of this method for mouse clicking more user friendly
        def include?(x, y)
          # assume a rectangular shape by default
          contain?(x, y)
        end

        def include_with_children?(x, y, except_child: nil)
          included = include?(x, y)
          included ||= expanded_shapes.reject {|shape| shape == except_child}.detect { |shape| shape.include?(x, y) }
        end
        
        # if there is a transform, invert it and apply on x, y point coordinates
        def inverse_transform_point(x, y)
          current_transform = (transform || parent_shape_containers.map(&:transform).first)&.first
          if current_transform
            transform_array = [1,2,3,4,5,6].to_java(:float)
            current_transform.getElements(transform_array)
            inverse_transform = TransformProxy.new(DisplayProxy.instance.swt_display, *transform_array.to_a)
            inverse_transform_array = [1,2,3,4,5,6].to_java(:float)
            inverse_transform.getElements(inverse_transform_array)
            matrix = Matrix[[inverse_transform_array[0], inverse_transform_array[1]], [inverse_transform_array[2], inverse_transform_array[3]]]
            result = matrix * Matrix.column_vector([x, y])
            x, y = result.to_a.flatten
            x += inverse_transform_array[5]
            y += inverse_transform_array[4]
          end
          [x, y]
        end

        # Indicates if a shape's x, y, width, height differ from its bounds calculation (e.g. arc / polygon)
        def irregular?
          false
        end
        
        # moves by x delta and y delta. Subclasses must implement
        # provdies a default implementation that assumes moving x and y is sufficient by default (not for polygons though, which must override)
        def move_by(x_delta, y_delta)
          if respond_to?(:x) && respond_to?(:y) && respond_to?(:x=) && respond_to?(:y=)
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
        alias translate move_by
        
        # rotates shape for an angle around its center
        # this operation is not cumulative (it resets angle every time)
        # consumers may inspect corresponding rotation_angle attribute to know which angle the shape is currently at for convenience
        # this overrides any pre-existing transforms that are applied to shape
        def rotate(angle)
          half_width = calculated_width/2.0
          half_height = calculated_height/2.0
          self.transform = Glimmer::SWT::TransformProxy.new(self).translate(half_width, half_height).rotate(angle).translate(-1.0*half_width, -1.0*half_height)
          @rotation_angle = angle
        end
        
        # returns rotation angle
        # consumers may inspect rotation_angle attribute to know which angle the shape is rotated at via rotate method
        # it is not guaranteed to give the right result if a transform is applied outside of rotate method.
        # starts at 0
        def rotation_angle
          @rotation_angle.to_f
        end
        
        def center_x
          center_x_dependencies = [x_end, calculated_width]
          if center_x_dependencies != @center_x_dependencies
            @center_x_dependencies = center_x_dependencies
            the_x_end, the_calculated_width = center_x_dependencies
            @center_x = the_x_end - the_calculated_width/2.0
          end
          @center_x
        end
        
        def center_y
          center_y_dependencies = [y_end, calculated_height]
          if center_y_dependencies != @center_y_dependencies
            @center_y_dependencies = center_y_dependencies
            the_y_end, the_calculated_height = center_y_dependencies
            @center_y = the_y_end - the_calculated_height/2.0
          end
          @center_y
        end
        
        def content(&block)
          Glimmer::SWT::DisplayProxy.instance.auto_exec do
            Glimmer::DSL::Engine.add_content(self, Glimmer::DSL::SWT::ShapeExpression.new, @name, &block)
            calculated_args_changed!(children: false)
          end
        end
        
        def has_some_background?
          @properties.keys.map(&:to_s).include?('background') || @properties.keys.map(&:to_s).include?('background_pattern')
        end
        
        def has_some_foreground?
          @properties.keys.map(&:to_s).include?('foreground') || @properties.keys.map(&:to_s).include?('foreground_pattern')
        end
        
        def post_add_content
          amend_method_name_options_based_on_properties!
          if !@content_added || @method_name != @original_method_name
            @drawable.setup_shape_painting unless @drawable.is_a?(ImageProxy)
            @content_added = true
          end
        end
        
        def apply_property_arg_conversions(property, args)
          method_name = attribute_setter(property)
          args = args.dup
          the_java_method = org.eclipse.swt.graphics.GC.java_class.declared_instance_methods.detect {|m| m.name == method_name}
          return args if the_java_method.nil?
          if the_java_method.parameter_types.first == org.eclipse.swt.graphics.Color.java_class && args.first.is_a?(org.eclipse.swt.graphics.RGB)
            args[0] = [args[0].red, args[0].green, args[0].blue]
          end
          if ['setBackground', 'setForeground'].include?(method_name.to_s) && args.first.is_a?(Array)
            args[0] = ColorProxy.new(args[0])
          end
          if method_name.to_s == 'setLineDash' && args.size > 1
            args[0] = args.dup
            args[1..-1] = []
          end
          if method_name.to_s == 'setAntialias' && [nil, true, false].include?(args.first)
            args[0] = case args.first
            when true
              args[0] = :on
            when false
              args[0] = :off
            when nil
              args[0] = :default
            end
          end
          if args.first.is_a?(Symbol) || args.first.is_a?(::String)
            if the_java_method.parameter_types.first == org.eclipse.swt.graphics.Color.java_class
              args[0] = ColorProxy.new(args[0])
            end
            if method_name.to_s == 'setLineStyle'
              args[0] = "line_#{args[0]}" if !args[0].to_s.downcase.start_with?('line_')
            end
            if method_name.to_s == 'setFillRule'
              args[0] = "fill_#{args[0]}" if !args[0].to_s.downcase.start_with?('fill_')
            end
            if method_name.to_s == 'setLineCap'
              args[0] = "cap_#{args[0]}" if !args[0].to_s.downcase.start_with?('cap_')
            end
            if method_name.to_s == 'setLineJoin'
              args[0] = "join_#{args[0]}" if !args[0].to_s.downcase.start_with?('join_')
            end
            if the_java_method.parameter_types.first == Java::int.java_class
              args[0] = SWTProxy.constant(args[0])
            end
          end
          if args.first.is_a?(ColorProxy)
            args[0] = args[0].swt_color
          end
          if (args.first.is_a?(Hash) || args.first.is_a?(org.eclipse.swt.graphics.FontData)) && the_java_method.parameter_types.first == org.eclipse.swt.graphics.Font.java_class
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
              arg = ColorProxy.new(arg.red, arg.green, arg.blue) if arg.is_a?(org.eclipse.swt.graphics.RGB)
              arg = ColorProxy.new(arg) if arg.is_a?(Symbol) || arg.is_a?(::String)
              arg = arg.swt_color if arg.is_a?(ColorProxy)
              args[i] = arg
            end
            @pattern_args ||= {}
            pattern_type = method_name.to_s.match(/set(.+)Pattern/)[1]
            if args.first.is_a?(org.eclipse.swt.graphics.Pattern)
              new_args = @pattern_args[pattern_type]
            else
              new_args = args.first.is_a?(org.eclipse.swt.widgets.Display) ? args : ([DisplayProxy.instance.swt_display] + args)
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
              @args[0] = ImageProxy.create(@args[0])
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
          if current_parameter_name?(:dest_x) && dest_x.nil?
            self.dest_x = :default
          elsif parameter_name?(:x) && x.nil?
            self.x = :default
          end
          if current_parameter_name?(:dest_y) && dest_y.nil?
            self.dest_y = :default
          elsif parameter_name?(:y) && y.nil?
            self.y = :default
          end
          self.width = :default if current_parameter_name?(:width) && width.nil?
          self.height = :default if current_parameter_name?(:height) && height.nil?
          if @name.include?('rectangle') && round? && @args.size.between?(4, 5)
            (6 - @args.size).times {@args << 60}
          elsif @name.include?('rectangle') && gradient? && @args.size == 4
            set_attribute('vertical', true, redraw: false)
          elsif (@name.include?('text') || @name.include?('string')) && !@properties.keys.map(&:to_s).include?('background') && @args.size < 4
            set_attribute('is_transparent', true, redraw: false)
          end
          if @name.include?('image')
            @drawable.requires_shape_disposal = true
          end
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
          @original_method_name = @method_name
          return if @name == 'point'
          if (@name != 'text' && @name != 'string' && has_some_background? && !has_some_foreground?) || (@name == 'path' && has_some_background?)
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
          [:x, :y, :width, :height]
        end
        
        # subclasses may override to specify location parameter names if different from x and y (e.g. all polygon points are location parameters)
        # used in calculating movement changes
        def location_parameter_names
          [:x, :y]
        end
        
        def possible_parameter_names
          parameter_names
        end
        
        def parameter_name?(attribute_name)
          possible_parameter_names.map(&:to_s).include?(ruby_attribute_getter(attribute_name))
        end
        
        def current_parameter_name?(attribute_name)
          parameter_names.include?(attribute_name.to_s.to_sym)
        end
        
        def parameter_index(attribute_name)
          parameter_names.index(attribute_name.to_s.to_sym)
        end
        
        def get_parameter_attribute(attribute_name)
          @args[parameter_index(ruby_attribute_getter(attribute_name))]
        end
        
        def set_parameter_attribute(attribute_name, *args)
          @args[parameter_index(ruby_attribute_getter(attribute_name))] = args.size == 1 ? args.first : args
        end
        
        def has_attribute?(attribute_name, *args)
          self.class.gc_instance_methods.include?(attribute_setter(attribute_name)) or
            parameter_name?(attribute_name) or
            (respond_to?(attribute_name, super: true) and respond_to?(ruby_attribute_setter(attribute_name), super: true))
        end
        
        def set_attribute(attribute_name, *args)
          options = args.last if args.last.is_a?(Hash)
          args.pop if !options.nil? && !options[:redraw].nil?
          options ||= {}
          perform_redraw = @perform_redraw
          perform_redraw = options[:redraw] if perform_redraw.nil? && !options.nil?
          perform_redraw ||= true
          property_change = nil
          ruby_attribute_getter_name = ruby_attribute_getter(attribute_name)
          ruby_attribute_setter_name = ruby_attribute_setter(attribute_name)
          if parameter_name?(attribute_name)
            return if ruby_attribute_getter_name == (args.size == 1 ? args.first : args)
            set_parameter_attribute(ruby_attribute_getter_name, *args)
          elsif (respond_to?(attribute_name, super: true) and respond_to?(ruby_attribute_setter_name, super: true))
            return if self.send(ruby_attribute_getter_name) == (args.size == 1 ? args.first : args)
            self.send(ruby_attribute_setter_name, *args)
          else
            # TODO consider this optimization of preconverting args (removing conversion from other methods) to reject equal args
            args = apply_property_arg_conversions(ruby_attribute_getter_name, args)
            return if @properties[ruby_attribute_getter_name] == args
            new_property = !@properties.keys.include?(ruby_attribute_getter_name)
            @properties[ruby_attribute_getter_name] = args
            amend_method_name_options_based_on_properties! if @content_added && new_property
            property_change = true
            calculated_paint_args_changed! if container?
          end
          if @content_added && perform_redraw && !drawable.is_disposed
            redrawn = false
            unless property_change
              calculated_paint_args_changed!(children: false)
              if is_a?(PathSegment)
                root_path&.calculated_path_args = @calculated_path_args = false
                calculated_args_changed!
                root_path&.calculated_args_changed!
              end
              if location_parameter_names.map(&:to_s).include?(ruby_attribute_getter_name)
                calculated_args_changed!(children: true)
                redrawn = parent.calculated_args_changed_for_defaults! if parent.is_a?(Shape)
              end
              if ['width', 'height'].include?(ruby_attribute_getter_name)
                redrawn = calculated_args_changed_for_defaults!
              end
            end
            # TODO consider redrawing an image proxy's gc in the future
            # TODO consider ensuring only a single redraw happens for a hierarchy of nested shapes
            drawable.redraw if !redrawn && !drawable.is_a?(ImageProxy)
          end
        end
        
        def get_attribute(attribute_name)
          if parameter_name?(attribute_name)
            arg_index = parameter_index(attribute_name)
            @args[arg_index] if arg_index
          elsif (respond_to?(attribute_name, super: true) and respond_to?(ruby_attribute_setter(attribute_name), super: true))
            self.send(attribute_name)
          else
            @properties[attribute_name.to_s]
          end
        end
        
        def can_handle_observation_request?(observation_request)
          drawable.can_handle_observation_request?(observation_request)
        end
        
        def handle_observation_request(observation_request, &block)
          shape_block = lambda do |event|
            block.call(event) if include_with_children?(event.x, event.y)
          end
          if observation_request == 'on_drop'
            Shape.drop_shapes << self
            handle_observation_request('on_mouse_up') do |event|
              if Shape.dragging && include_with_children?(event.x, event.y, except_child: Shape.dragged_shape)
                drop_event = DropEvent.new(
                  doit: true,
                  dragged_shape: Shape.dragged_shape,
                  dragged_shape_original_x: Shape.dragged_shape_original_x,
                  dragged_shape_original_y: Shape.dragged_shape_original_y,
                  dragging_x: Shape.dragging_x,
                  dragging_y: Shape.dragging_y,
                  drop_shapes: Shape.drop_shapes,
                  x: event.x,
                  y: event.y
                )
                begin
                  block.call(drop_event)
                rescue => e
                  Glimmer::Config.logger.error e.full_message
                ensure
                  Shape.dragging = false
                  if !drop_event.doit && Shape.dragged_shape
                    Shape.dragged_shape.x = Shape.dragged_shape_original_x
                    Shape.dragged_shape.y = Shape.dragged_shape_original_y
                  end
                  Shape.dragged_shape = nil
                end
              end
            end
          else
            drawable.handle_observation_request(observation_request, &shape_block)
          end
        end
        
        # Sets data just like SWT widgets
        def set_data(key=nil, value)
          @data ||= {}
          @data[key] = value
        end
        alias setData set_data # for compatibility with SWT APIs
  
        # Gets data just like SWT widgets
        def get_data(key=nil)
          @data ||= {}
          @data[key]
        end
        alias getData get_data # for compatibility with SWT APIs
        alias data get_data # for compatibility with SWT APIs
  
        def method_missing(method_name, *args, &block)
          if method_name.to_s.end_with?('=')
            set_attribute(method_name, *args)
          elsif has_attribute?(method_name)
            get_attribute(method_name)
          else # TODO support proxying calls to handle_observation_request for listeners just like WidgetProxy
            super
          end
        end
        
        def respond_to?(method_name, *args, &block)
          options = args.last if args.last.is_a?(Hash)
          super_invocation = options && options[:super]
          if !super_invocation && has_attribute?(method_name)
            true
          else
            super
          end
        end
          
        def drag_and_move=(drag_and_move_value)
          drag_and_move_old_value = @drag_and_move
          @drag_and_move = drag_and_move_value
          if @drag_and_move && !drag_and_move_old_value
            @on_drag_detected = handle_observation_request('on_drag_detected') do |event|
              Shape.dragging = true
              Shape.dragging_x = event.x
              Shape.dragging_y = event.y
              Shape.dragged_shape = self
              Shape.dragged_shape_original_x = x
              Shape.dragged_shape_original_y = y
            end
            @drawable_on_mouse_move = drawable.handle_observation_request('on_mouse_move') do |event|
              if Shape.dragging && Shape.dragged_shape == self
                Shape.dragged_shape.move_by((event.x - Shape.dragging_x), (event.y - Shape.dragging_y))
                Shape.dragging_x = event.x
                Shape.dragging_y = event.y
              end
            end
            @drawable_on_mouse_up = drawable.handle_observation_request('on_mouse_up') do |event|
              if Shape.dragging && Shape.dragged_shape == self
                Shape.dragging = false
              end
            end
          elsif !@drag_and_move && drag_and_move_old_value
            @on_drag_detected.deregister
            @drawable_on_mouse_move.deregister
            @drawable_on_mouse_up.deregister
          end
        end
            
        def drag_and_move
          @drag_and_move
        end
        
        def drag_source=(drag_source_value)
          drag_source_old_value = @drag_source
          @drag_source = drag_source_value
          if @drag_source && !drag_source_old_value
            @on_drag_detected = handle_observation_request('on_drag_detected') do |event|
              Shape.dragging = true
              Shape.dragging_x = event.x
              Shape.dragging_y = event.y
              Shape.dragged_shape = self
              Shape.dragged_shape_original_x = x
              Shape.dragged_shape_original_y = y
            end
            @drawable_on_mouse_move = drawable.handle_observation_request('on_mouse_move') do |event|
              if Shape.dragging && Shape.dragged_shape == self
                Shape.dragged_shape.move_by((event.x - Shape.dragging_x), (event.y - Shape.dragging_y))
                Shape.dragging_x = event.x
                Shape.dragging_y = event.y
              end
            end
            @drawable_on_mouse_up = drawable.handle_observation_request('on_mouse_up') do |event|
              if Shape.dragging && Shape.dragged_shape == self && !Shape.drop_shapes.detect {|shape| shape.include_with_children?(event.x, event.y, except_child: Shape.dragged_shape)}
                Shape.dragging = false
                Shape.dragged_shape.x = Shape.dragged_shape_original_x
                Shape.dragged_shape.y = Shape.dragged_shape_original_y
                Shape.dragged_shape = nil
              end
            end
          elsif !@drag_source && drag_source_old_value
            @on_drag_detected.deregister
            @drawable_on_mouse_move.deregister
            @drawable_on_mouse_up.deregister
          end
        end
            
        def drag_source
          @drag_source
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
        
        def dispose(dispose_images: true, dispose_patterns: true, redraw: true)
          shapes.each { |shape| shape.is_a?(Shape::Path) && shape.dispose } # TODO look into why I'm only disposing paths
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
          drawable.redraw if redraw && !drawable.is_a?(ImageProxy)
        end
        
        # clear all shapes
        # indicate whether to dispose images, dispose patterns, and redraw after clearing shapes.
        # redraw can be `:all` or `true` to mean redraw after all shapes are disposed, `:each` to mean redraw after each shape is disposed, or `false` to avoid redraw altogether
        def clear_shapes(dispose_images: true, dispose_patterns: true, redraw: :all)
          if redraw == true || redraw == :all
            shapes.dup.each {|shape| shape.dispose(dispose_images: dispose_images, dispose_patterns: dispose_patterns, redraw: false) }
            drawable.redraw if redraw && !drawable.is_a?(ImageProxy)
          elsif redraw == :each
            shapes.dup.each {|shape| shape.dispose(dispose_images: dispose_images, dispose_patterns: dispose_patterns, redraw: true) }
          else
            shapes.dup.each {|shape| shape.dispose(dispose_images: dispose_images, dispose_patterns: dispose_patterns, redraw: false) }
          end
        end
        alias dispose_shapes clear_shapes
        
        # Indicate if this is a container shape (meaning a shape bag that is just there to contain nested shapes, but doesn't render anything of its own)
        def container?
          @name == 'shape'
        end
        
        # Indicate if this is a composite shape (meaning a shape that contains nested shapes like a rectangle with ovals inside it)
        def composite?
          !shapes.empty?
        end
        
        # ordered from closest to farthest parent
        def parent_shapes
          if @parent_shapes.nil?
            if parent.is_a?(Drawable)
              @parent_shapes = []
            else
              @parent_shapes = parent.parent_shapes + [parent]
            end
          end
          @parent_shapes
        end
        
        # ordered from closest to farthest parent
        def parent_shape_containers
          if @parent_shape_containers.nil?
            if parent.is_a?(Drawable)
              @parent_shape_containers = []
            elsif !parent.container?
              @parent_shape_containers = parent.parent_shape_containers
            else
              @parent_shape_containers = parent.parent_shape_containers + [parent]
            end
          end
          @parent_shape_containers
        end
        
        # ordered from closest to farthest parent
        def parent_shape_composites
          if @parent_shape_composites.nil?
            if parent.is_a?(Drawable)
              @parent_shape_composites = []
            elsif !parent.container?
              @parent_shape_composites = parent.parent_shape_composites
            else
              @parent_shape_composites = parent.parent_shape_composites + [parent]
            end
          end
          @parent_shape_composites
        end
        
        def convert_properties!
          if @properties != @converted_properties
            @properties.each do |property, args|
              @properties[property] = apply_property_arg_conversions(property, args)
            end
            @converted_properties = @properties.dup
          end
        end
        
        def converted_properties
          convert_properties!
          @properties
        end
        
        def all_parent_properties
          @all_parent_properties ||= parent_shape_containers.reverse.reduce({}) do |all_properties, parent_shape|
            all_properties.merge(parent_shape.converted_properties)
          end
        end
        
        def paint(paint_event)
          paint_children(paint_event) if default_width? || default_height?
          paint_self(paint_event)
          # re-paint children from scratch in the special case of pre-calculating parent width/height to re-center within new parent dimensions
          shapes.each(&:calculated_args_changed!) if default_width? || default_height?
          paint_children(paint_event)
        rescue => e
          Glimmer::Config.logger.error {"Error encountered in painting shape (#{self.inspect}) with calculated args (#{@calculated_args}) and args (#{@args})"}
          Glimmer::Config.logger.error {e.full_message}
        end
        
        def paint_self(paint_event)
          @painting = true
          unless container?
            calculate_paint_args!
            @original_gc_properties = {} # this stores GC properties before making calls to updates TODO avoid using in pixel graphics
            @properties.each do |property, args|
              method_name = attribute_setter(property)
              @original_gc_properties[method_name] = paint_event.gc.send(method_name.sub('set', 'get')) rescue nil
              paint_event.gc.send(method_name, *args)
              if property == 'transform' && args.first.is_a?(TransformProxy)
                args.first.swt_transform.dispose
              end
            end
            ensure_extent(paint_event)
          end
          @calculated_args ||= calculate_args!
          unless container?
            # paint unless parent's calculated args are not calculated yet, meaning it is about to get painted and trigger a paint on this child anyways
            paint_event.gc.send(@method_name, *@calculated_args) unless (parent.is_a?(Shape) && !parent.calculated_args?)
            @original_gc_properties.each do |method_name, value|
              paint_event.gc.send(method_name, value)
            end
          end
          @painting = false
        rescue => e
          Glimmer::Config.logger.error {"Error encountered in painting shape (#{self.inspect}) with method (#{@method_name}) calculated args (#{@calculated_args}) and args (#{@args})"}
          Glimmer::Config.logger.error {e.full_message}
        ensure
          @painting = false
        end
        
        def paint_children(paint_event)
          shapes.to_a.each do |shape|
            shape.paint(paint_event)
          end
        end
        
        def ensure_extent(paint_event)
          old_extent = @extent
          if ['text', 'string'].include?(@name)
            extent_args = [string]
            extent_flags = SWTProxy[:draw_transparent] if current_parameter_name?(:is_transparent) && is_transparent
            extent_flags = flags if current_parameter_name?(:flags)
            extent_args << extent_flags unless extent_flags.nil?
            self.extent = paint_event.gc.send("#{@name}Extent", *extent_args)
          end
          if !@extent.nil? && (old_extent&.x != @extent&.x || old_extent&.y != @extent&.y) # TODO add a check to text content changing too
            calculated_args_changed!
            parent.calculated_args_changed_for_defaults! if parent.is_a?(Shape)
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
        
        def calculated_args_changed!(children: true)
          # TODO add a children: true option to enable setting to false to avoid recalculating children args
          @calculated_args = nil
          shapes.each(&:calculated_args_changed!) if children
        end
        
        def calculated_paint_args_changed!(children: true)
          @calculated_paint_args = nil
          @all_parent_properties = nil
          shapes.each(&:calculated_paint_args_changed!) if children
        end
        
        # Notifies object that calculated args changed for defaults. Returns true if redrawing and false otherwise.
        def calculated_args_changed_for_defaults!
          has_default_dimensions = default_width? || default_height?
          parent_calculated_args_changed_for_defaults = has_default_dimensions
          calculated_args_changed!(children: false) if default_x? || default_y? || has_default_dimensions
          if has_default_dimensions && parent.is_a?(Shape)
            parent.calculated_args_changed_for_defaults!
          elsif @content_added && !drawable.is_disposed
            # TODO consider optimizing in the future if needed by ensuring one redraw for all parents in the hierarchy at the end instead of doing one per parent that needs it
            if !@painting && !drawable.is_a?(ImageProxy)
              drawable.redraw
              return true
            end
          end
          false
        end
        
        def calculated_args?
          !!@calculated_args
        end
                
        # args translated to absolute coordinates
        def calculate_args!
        # TODO add conditions for parent having default width/height too
          return @args if parent.is_a?(Drawable) && !default_x? && !default_y? && !default_width? && !default_height? && !max_width? && !max_height?
          calculated_args_dependencies = [
            x,
            y,
            parent.is_a?(Shape) && parent.absolute_x,
            parent.is_a?(Shape) && parent.absolute_y,
            default_width? && default_width,
            default_width? && width_delta,
            default_height? && default_height,
            default_height? && height_delta,
            max_width? && max_width,
            max_width? && width_delta,
            max_height? && max_height,
            max_height? && height_delta,
            default_x? && default_x,
            default_x? && x_delta,
            default_y? && default_y,
            default_y? && y_delta,
          ]
          if calculated_args_dependencies != @calculated_args_dependencies
            # avoid recalculating values again
            x, y, parent_absolute_x, parent_absolute_y, default_width, default_width_delta, default_height, default_height_delta, max_width, max_width_delta, max_height, max_height_delta, default_x, default_x_delta, default_y, default_y_delta = @calculated_args_dependencies = calculated_args_dependencies
            # Note: Must set x and move_by because not all shapes have a real x and some must translate all their points with move_by
            # TODO change that by setting a bounding box for all shapes with a calculated top-left x, y and
            # a setter that does the moving inside them instead so that I could rely on absolute_x and absolute_y
            # here to get the job done of calculating absolute args
            @perform_redraw = false
            original_x = nil
            original_y = nil
            original_width = nil
            original_height = nil
            if parent.is_a?(Shape)
              @parent_absolute_x = parent_absolute_x
              @parent_absolute_y = parent_absolute_y
            end
            if default_width?
              original_width = width
              self.width = default_width + default_width_delta
            end
            if default_height?
              original_height = height
              self.height = default_height + default_height_delta
            end
            if max_width?
              original_width = width
              self.width = max_width + max_width_delta
            end
            if max_height?
              original_height = height
              self.height = max_height + max_height_delta
            end
            if default_x?
              original_x = x
              self.x = default_x + default_x_delta
            end
            if default_y?
              original_y = y
              self.y = default_y + default_y_delta
            end
            if parent.is_a?(Shape)
              move_by(@parent_absolute_x, @parent_absolute_y)
              @result_calculated_args = @args.clone
              move_by(-1*@parent_absolute_x, -1*@parent_absolute_y)
            else
              @result_calculated_args = @args.clone
            end
            if original_x
              self.x = original_x
            end
            if original_y
              self.y = original_y
            end
            if original_width
              self.width = original_width
            end
            if original_height
              self.height = original_height
            end
            @perform_redraw = true
          end
          @result_calculated_args
        end
        
        def default_x?
          return false unless current_parameter_name?(:x)
          x = self.x
          x.nil? || x.to_s == 'default' || (x.is_a?(Array) && x.first.to_s == 'default')
        end
        
        def default_y?
          return false unless current_parameter_name?(:y)
          y = self.y
          y.nil? || y.to_s == 'default' || (y.is_a?(Array) && y.first.to_s == 'default')
        end
        
        def default_width?
          return false unless current_parameter_name?(:width)
          width = self.width
          (width.nil? || width == :default || width == 'default' || (width.is_a?(Array) && (width.first.to_s == :default || width.first.to_s == 'default')))
        end
        
        def default_height?
          return false unless current_parameter_name?(:height)
          height = self.height
          (height.nil? || height == :default || height == 'default' || (height.is_a?(Array) && (height.first.to_s == :default || height.first.to_s == 'default')))
        end
        
        def max_width?
          return false unless current_parameter_name?(:width)
          width = self.width
          (width.nil? || width.to_s == 'max' || (width.is_a?(Array) && width.first.to_s == 'max'))
        end
        
        def max_height?
          return false unless current_parameter_name?(:height)
          height = self.height
          (height.nil? || height.to_s == 'max' || (height.is_a?(Array) && height.first.to_s == 'max'))
        end
        
        def default_x
          default_x_dependencies = [parent.size.x, size.x, parent.is_a?(Shape) && parent.irregular? && parent.bounds.x, parent.is_a?(Shape) && parent.irregular? && parent.absolute_x]
          if default_x_dependencies != @default_x_dependencies
            @default_x_dependencies = default_x_dependencies
            result = ((parent.size.x - size.x) / 2)
            result += parent.bounds.x - parent.absolute_x if parent.is_a?(Shape) && parent.irregular?
            @default_x = result
          end
          @default_x
        end
        
        def default_y
          default_y_dependencies = [parent.size.y, size.y, parent.is_a?(Shape) && parent.irregular? && parent.bounds.y, parent.is_a?(Shape) && parent.irregular? && parent.absolute_y]
          if default_y_dependencies != @default_y_dependencies
            result = ((parent.size.y - size.y) / 2)
            result += parent.bounds.y - parent.absolute_y if parent.is_a?(Shape) && parent.irregular?
            @default_y = result
          end
          @default_y
        end
        
        # right-most x coordinate in this shape (adding up its width and location)
        def x_end
          x_end_dependencies = [calculated_width, default_x?, !default_x? && x]
          if x_end_dependencies != @x_end_dependencies
            # avoid recalculation of dependencies
            calculated_width, is_default_x, x = @x_end_dependencies = x_end_dependencies
            shape_width = calculated_width.to_f
            shape_x = is_default_x ? 0 : x.to_f
            @x_end = shape_x + shape_width
          end
          @x_end
        end
        
        # bottom-most y coordinate in this shape (adding up its height and location)
        def y_end
          y_end_dependencies = [calculated_height, default_y?, !default_y? && y]
          if y_end_dependencies != @y_end_dependencies
            # avoid recalculation of dependencies
            calculated_height, is_default_y, y = @y_end_dependencies = y_end_dependencies
            shape_height = calculated_height.to_f
            shape_y = is_default_y ? 0 : y.to_f
            @y_end = shape_y + shape_height
          end
          @y_end
        end
        
        def default_width
          default_width_dependencies = [shapes.empty? && max_width, shapes.size == 1 && shapes.first.max_width? && parent.size.x, shapes.size >= 1 && !shapes.first.max_width? && shapes.map {|s| s.max_width? ? 0 : s.x_end}]
          if default_width_dependencies != @default_width_dependencies
            # Do not repeat calculations
            max_width, parent_size_x, x_ends = @default_width_dependencies = default_width_dependencies
            @default_width = if shapes.empty?
              max_width
            elsif shapes.size == 1 && shapes.first.max_width?
              parent_size_x
            else
              x_ends.max.to_f
            end
          end
          @default_width
        end
        
        def default_height
          default_height_dependencies = [shapes.empty? && max_height, shapes.size == 1 && shapes.first.max_height? && parent.size.y, shapes.size >= 1 && !shapes.first.max_height? && shapes.map {|s| s.max_height? ? 0 : s.y_end}]
          if default_height_dependencies != @default_height_dependencies
            # Do not repeat calculations
            max_height, parent_size_y, y_ends = @default_height_dependencies = default_height_dependencies
            @default_height = if shapes.empty?
              max_height
            elsif shapes.size == 1 && shapes.first.max_height?
              parent_size_y
            else
              y_ends.max.to_f
            end
          end
          @default_height
        end
        
        def max_width
          max_width_dependencies = [parent.is_a?(Drawable) && parent.size.x, !parent.is_a?(Drawable) && parent.calculated_width]
          if max_width_dependencies != @max_width_dependencies
            # do not repeat calculations
            parent_size_x, parent_calculated_width = @max_width_dependencies = max_width_dependencies
            @max_width = parent.is_a?(Drawable) ? parent_size_x : parent_calculated_width
          end
          @max_width
        end
        
        def max_height
          max_height_dependencies = [parent.is_a?(Drawable) && parent.size.y, !parent.is_a?(Drawable) && parent.calculated_height]
          if max_height_dependencies != @max_height_dependencies
            # do not repeat calculations
            parent_size_y, parent_calculated_height = @max_height_dependencies = max_height_dependencies
            @max_height = parent.is_a?(Drawable) ? parent_size_y : parent_calculated_height
          end
          @max_height
        end
        
        def calculated_width
          calculated_width_dependencies = [width, default_width? && (default_width + width_delta), max_width? && (max_width + width_delta)]
          if calculated_width_dependencies != @calculated_width_dependencies
            @calculated_width_dependencies = calculated_width_dependencies
            result_width = width
            result_width = (default_width + width_delta) if default_width?
            result_width = (max_width + width_delta) if max_width?
            @calculated_width = result_width
          end
          @calculated_width
        end
        
        def calculated_height
          calculated_height_dependencies = [height, default_height? && (default_height + height_delta), max_height? && (max_height + height_delta)]
          if calculated_height_dependencies != @calculated_height_dependencies
            @calculated_height_dependencies = calculated_height_dependencies
            result_height = height
            result_height = (default_height + height_delta) if default_height?
            result_height = (max_height + height_delta) if max_height?
            @calculated_height = result_height
          end
          @calculated_height
        end
        
        def x_delta
          return 0 unless x.is_a?(Array) && default_x?
          x[1].to_f
        end
        
        def y_delta
          return 0 unless y.is_a?(Array) && default_y?
          y[1].to_f
        end
        
        def width_delta
          return 0 unless width.is_a?(Array) && (default_width? || max_width?)
          width[1].to_f
        end
        
        def height_delta
          return 0 unless height.is_a?(Array) && (default_height? || max_height?)
          height[1].to_f
        end
        
        def x_delta=(delta)
          return unless default_x?
          symbol = x.is_a?(Array) ? x.first : x
          self.x = [symbol, delta]
        end
        
        def y_delta=(delta)
          return unless default_y?
          symbol = y.is_a?(Array) ? y.first : y
          self.y = [symbol, delta]
        end
        
        def width_delta=(delta)
          return unless default_width?
          symbol = width.is_a?(Array) ? width.first : width
          self.width = [symbol, delta]
        end
        
        def height_delta=(delta)
          return unless default_height?
          symbol = height.is_a?(Array) ? height.first : height
          self.height = [symbol, delta]
        end
        
        def calculated_x
          calculated_x_dependencies = [default_x? && default_x, !default_x? && self.x, self.x_delta]
          if calculated_x_dependencies != @calculated_x_dependencies
            default_x, x, x_delta = @calculated_x_dependencies = calculated_x_dependencies
            result = default_x? ? default_x : x
            result += x_delta
            @calculated_x = result
          end
          @calculated_x
        end
        
        def calculated_y
          calculated_y_dependencies = [default_y? && default_y, !default_y? && self.y, self.y_delta]
          if calculated_y_dependencies != @calculated_y_dependencies
            default_y, y, y_delta = @calculated_y_dependencies = calculated_y_dependencies
            result = default_y? ? default_y : y
            result += y_delta
            @calculated_y = result
          end
          @calculated_y
        end
        
        def absolute_x
          absolute_x_dependencies = [calculated_x, parent.is_a?(Shape) && parent.absolute_x]
          if absolute_x_dependencies != @absolute_x_dependencies
            # do not repeat calculations
            calculated_x, parent_absolute_x = @absolute_x_dependencies = absolute_x_dependencies
            x = calculated_x
            @absolute_x = if parent.is_a?(Shape)
              parent_absolute_x + x
            else
              x
            end
          end
          @absolute_x
        end
        
        def absolute_y
          absolute_y_dependencies = [calculated_y, parent.is_a?(Shape) && parent.absolute_y]
          if absolute_y_dependencies != @absolute_y_dependencies
            calculated_y, parent_absolute_y = @absolute_y_dependencies = absolute_y_dependencies
            y = calculated_y
            @absolute_y = if parent.is_a?(Shape)
              parent_absolute_y + y
            else
              y
            end
          end
          @absolute_y
        end
        
        # Overriding inspect to avoid printing very long nested shape hierarchies (recurses onces only)
        def inspect(recursive: 1, calculated: false, args: true, properties: true, calculated_args: false)
          recurse = recursive == true || recursive.is_a?(Integer) && recursive.to_i > 0
          recursive = [recursive -= 1, 0].max if recursive.is_a?(Integer)
          args_string = " args=#{@args.inspect}" if args
          properties_string = " properties=#{@properties.inspect}}" if properties
          calculated_args_string = " calculated_args=#{@calculated_args.inspect}" if calculated_args
          calculated_string = " absolute_x=#{absolute_x} absolute_y=#{absolute_y} calculated_width=#{calculated_width} calculated_height=#{calculated_height}" if calculated
          recursive_string = " shapes=#{@shapes.map {|s| s.inspect(recursive: recursive, calculated: calculated, args: args, properties: properties)}}" if recurse
          "#<#{self.class.name}:0x#{self.hash.to_s(16)}#{args_string}#{properties_string}#{calculated_args_string}#{calculated_string}#{recursive_string}>"
        rescue => e
          Glimmer::Config.logger.error { e.full_message }
          "#<#{self.class.name}:0x#{self.hash.to_s(16)}"
        end
        
        def calculate_paint_args!
          unless @calculated_paint_args
            if @name == 'pixel'
              @name = 'point'
              # optimized performance calculation for pixel points
              if !@properties[:foreground].is_a?(org.eclipse.swt.graphics.Color)
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
              @original_properties ||= @properties
              @properties = all_parent_properties.merge(@original_properties)
              @properties['background'] = [@drawable.background] if fill? && !has_some_background?
              @properties['foreground'] = [@drawable.foreground] if @drawable.respond_to?(:foreground) && draw? && !has_some_foreground?
              # TODO regarding alpha, make sure to reset it to parent stored alpha once we allow setting shape properties on parents directly without shapes
              @properties['font'] = [@drawable.font] if @drawable.respond_to?(:font) && @name == 'text' && draw? && !@properties.keys.map(&:to_s).include?('font')
              # TODO regarding transform, make sure to reset it to parent stored transform once we allow setting shape properties on parents directly without shapes
              # Also do that with all future-added properties
              convert_properties!
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
