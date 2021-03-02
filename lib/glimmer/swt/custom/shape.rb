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
        attr_accessor :extent
        
        def initialize(parent, keyword, *args, &property_block)
          @parent = parent
          @drawable = @parent.is_a?(Drawable) ? @parent : @parent.drawable
          @name = keyword
          @options = self.class.arg_options(args, extract: true)
          @method_name = self.class.method_name(keyword, @options)
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
          org.eclipse.swt.graphics.Rectangle.new(absolute_x, absolute_y, calculated_width, calculated_height)
        end
        
        # The bounding box top-left x and y
        def location
          org.eclipse.swt.graphics.Point.new(bounds.x, bounds.y)
        end
        
        # The bounding box width and height (as a Point object with x being width and y being height)
        def size
          org.eclipse.swt.graphics.Point.new(calculated_width, calculated_height)
        end
        
        def extent
          @extent || size
        end
        
        # Returns if shape contains a point
        # Subclasses (like polygon) may override to indicate if a point x,y coordinates falls inside the shape
        # some shapes may choose to provide a fuzz factor to make usage of this method for mouse clicking more user friendly
        def contain?(x, y)
          # assume a rectangular filled shape by default (works for several shapes like image, text, and focus)
          x.between?(self.absolute_x, self.absolute_x + calculated_width) && y.between?(self.absolute_y, self.absolute_y + calculated_height)
        end
        
        # Returns if shape includes a point. When the shape is filled, this is the same as contain. When the shape is drawn, it only returns true if the point lies on the edge (boundary/border)
        # Subclasses (like polygon) may override to indicate if a point x,y coordinates falls on the edge of a drawn shape or inside a filled shape
        # some shapes may choose to provide a fuzz factor to make usage of this method for mouse clicking more user friendly
        def include?(x, y)
          # assume a rectangular shape by default
          contain?(x, y)
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
              self.default_x_delta += x_delta
            else
              self.x += x_delta
            end
            if default_y?
              self.default_y_delta += y_delta
            else
              self.y += y_delta
            end
          end
        end
        
        def content(&block)
          Glimmer::SWT::DisplayProxy.instance.auto_exec do
            Glimmer::DSL::Engine.add_content(self, Glimmer::DSL::SWT::ShapeExpression.new, &block)
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
        
        def apply_property_arg_conversions(method_name, property, args)
          args = args.dup
          the_java_method = org.eclipse.swt.graphics.GC.java_class.declared_instance_methods.detect {|m| m.name == method_name}
          return args if the_java_method.nil?
          if the_java_method.parameter_types.first == Color.java_class && args.first.is_a?(RGB)
            args[0] = [args[0].red, args[0].green, args[0].blue]
          end
          if ['setBackground', 'setForeground'].include?(method_name.to_s) && args.first.is_a?(Array)
            args[0] = ColorProxy.new(args[0])
          end
          if method_name.to_s == 'setLineDash' && args.size > 1
            args[0] = args.dup
            args[1..-1] = []
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
          self.x = :default if current_parameter_name?(:x) && x.nil?
          self.y = :default if current_parameter_name?(:y) && y.nil?
          self.dest_x = :default if current_parameter_name?(:dest_x) && dest_x.nil?
          self.dest_y = :default if current_parameter_name?(:dest_y) && dest_y.nil?
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
          perform_redraw = @perform_redraw
          perform_redraw = options[:redraw] if perform_redraw.nil? && !options.nil?
          perform_redraw = true if perform_redraw.nil?
          if parameter_name?(attribute_name)
            set_parameter_attribute(attribute_name, *args)
          elsif (respond_to?(attribute_name, super: true) and respond_to?(ruby_attribute_setter(attribute_name), super: true))
            self.send(ruby_attribute_setter(attribute_name), *args)
          else
            @properties[ruby_attribute_getter(attribute_name)] = args
          end
          if @content_added && perform_redraw && !drawable.is_disposed
            @calculated_paint_args = false
            if is_a?(PathSegment)
              root_path&.calculated_path_args = @calculated_path_args = false
              calculated_args_changed!
              root_path&.calculated_args_changed!
            end
            attribute_name = ruby_attribute_getter(attribute_name)
            if location_parameter_names.map(&:to_s).include?(attribute_name)
              @calculated_args = nil
              parent.calculated_args_changed_for_defaults! if parent.is_a?(Shape)
            end
            if ['width', 'height'].include?(attribute_name)
              calculated_args_changed_for_defaults!
            end
            # TODO consider redrawing an image proxy's gc in the future
            drawable.redraw unless drawable.is_a?(ImageProxy)
          end
        end
        
        def get_attribute(attribute_name)
          if parameter_name?(attribute_name)
            arg_index = parameter_index(attribute_name)
            @args[arg_index] if arg_index
          elsif (respond_to?(attribute_name, super: true) and respond_to?(ruby_attribute_setter(attribute_name), super: true))
            self.send(attribute_name)
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
          options = args.last if args.last.is_a?(Hash)
          super_invocation = options && options[:super]
          if !super_invocation && has_attribute?(method_name)
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
          shapes.each { |shape| shape.is_a?(Shape::Path) && shape.dispose }
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
          # pre-paint children an extra-time first when default width/height need to be calculated for defaults
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
          calculate_paint_args!
          @original_properties_backup = {}
          @properties.each do |property, args|
            method_name = attribute_setter(property)
            @original_properties_backup[method_name] = paint_event.gc.send(method_name.sub('set', 'get')) rescue nil
            paint_event.gc.send(method_name, *args)
            if property == 'transform' && args.first.is_a?(TransformProxy)
              args.first.swt_transform.dispose
            end
          end
          ensure_extent(paint_event)
          if !@calculated_args || parent_shape_absolute_location_changed?
            @calculated_args = calculated_args
          end
          # paint unless parent's calculated args are not calculated yet, meaning it is about to get painted and trigger a paint on this child anyways
          paint_event.gc.send(@method_name, *@calculated_args) unless parent.is_a?(Shape) && !parent.calculated_args?
          @original_properties_backup.each do |method_name, value|
            paint_event.gc.send(method_name, value)
          end
          @painting = false
        rescue => e
          Glimmer::Config.logger.error {"Error encountered in painting shape (#{self.inspect}) with calculated args (#{@calculated_args}) and args (#{@args})"}
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
          if !@extent.nil? && (old_extent&.x != @extent&.x || old_extent&.y != @extent&.y)
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
        
        def parent_shape_absolute_location_changed?
          (parent.is_a?(Shape) && (parent.absolute_x != @parent_absolute_x || parent.absolute_y != @parent_absolute_y))
        end
        
        def calculated_args_changed!(children: true)
          # TODO add a children: true option to enable setting to false to avoid recalculating children args
          @calculated_args = nil
          shapes.each(&:calculated_args_changed!) if children
        end
        
        def calculated_args_changed_for_defaults!
          has_default_dimensions = default_width? || default_height?
          parent_calculated_args_changed_for_defaults = has_default_dimensions
          @calculated_args = nil if default_x? || default_y? || has_default_dimensions
          if has_default_dimensions && parent.is_a?(Shape)
            parent.calculated_args_changed_for_defaults!
          elsif @content_added && !drawable.is_disposed
            # TODO consider optimizing in the future if needed by ensuring one redraw for all parents in the hierarchy at the end instead of doing one per parent that needs it
            drawable.redraw if !@painting && !drawable.is_a?(ImageProxy)
          end
        end
        
        def calculated_args?
          !!@calculated_args
        end
                
        # args translated to absolute coordinates
        def calculated_args
          return @args if !default_x? && !default_y? && !default_width? && !default_height? && parent.is_a?(Drawable)
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
            @parent_absolute_x = parent.absolute_x
            @parent_absolute_y = parent.absolute_y
          end
          if default_width?
            original_width = width
            self.width = default_width + default_width_delta
          end
          if default_height?
            original_height = height
            self.height = default_height + default_height_delta
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
            result_args = @args.clone
            move_by(-1*@parent_absolute_x, -1*@parent_absolute_y)
          else
            result_args = @args.clone
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
          result_args
        end
        
        def default_x?
          current_parameter_name?(:x) and
            (x.nil? || x.to_s == 'default' || (x.is_a?(Array) && x.first.to_s == 'default'))
        end
        
        def default_y?
          current_parameter_name?(:y) and
            (y.nil? || y.to_s == 'default' || (y.is_a?(Array) && y.first.to_s == 'default'))
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
        
        def default_x
          result = ((parent.size.x - size.x) / 2)
          result += parent.bounds.x - parent.absolute_x if parent.is_a?(Shape) && parent.irregular?
          result
        end
        
        def default_y
          result = ((parent.size.y - size.y) / 2)
          result += parent.bounds.y - parent.absolute_y if parent.is_a?(Shape) && parent.irregular?
          result
        end
        
        def default_width
          # TODO consider caching
          x_ends = shapes.map do |shape|
            shape_width = shape.calculated_width.to_f
            shape_x = shape.default_x? ? 0 : shape.x.to_f
            shape_x + shape_width
          end
          x_ends.max.to_f
        end
        
        def default_height
          # TODO consider caching
          y_ends = shapes.map do |shape|
            shape_height = shape.calculated_height.to_f
            shape_y = shape.default_y? ? 0 : shape.y.to_f
            shape_y + shape_height
          end
          y_ends.max.to_f
        end
        
        def calculated_width
          default_width? ? (default_width + default_width_delta) : width
        end
        
        def calculated_height
          default_height? ? (default_height + default_height_delta) : height
        end
        
        def default_x_delta
          return 0 unless default_x? && x.is_a?(Array)
          x[1].to_f
        end
        
        def default_y_delta
          return 0 unless default_y? && y.is_a?(Array)
          y[1].to_f
        end
        
        def default_width_delta
          return 0 unless default_width? && width.is_a?(Array)
          width[1].to_f
        end
        
        def default_height_delta
          return 0 unless default_height? && height.is_a?(Array)
          height[1].to_f
        end
        
        def default_x_delta=(delta)
          return unless default_x?
          self.x = [:default, delta]
        end
        
        def default_y_delta=(delta)
          return unless default_y?
          self.y = [:default, delta]
        end
        
        def default_width_delta=(delta)
          return unless default_width?
          self.width = [:default, delta]
        end
        
        def default_height_delta=(delta)
          return unless default_height?
          self.height = [:default, delta]
        end
        
        def calculated_x
          result = default_x? ? default_x : self.x
          result += default_x_delta
          result
        end
        
        def calculated_y
          result = default_y? ? default_y : self.y
          result += default_y_delta
          result
        end
        
        def absolute_x
          x = calculated_x
          if parent.is_a?(Shape)
            parent.absolute_x + x
          else
            x
          end
        end
        
        def absolute_y
          y = calculated_y
          if parent.is_a?(Shape)
            parent.absolute_y + y
          else
            y
          end
        end
        
        # Overriding inspect to avoid printing very long shape hierarchies
        def inspect
          "#<#{self.class.name}:0x#{self.hash.to_s(16)} args=#{@args.inspect}, properties=#{@properties.inspect}}>"
        rescue => e
          "#<#{self.class.name}:0x#{self.hash.to_s(16)}"
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
              # TODO regarding transform, make sure to reset it to parent stored transform once we allow setting shape properties on parents directly without shapes
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
