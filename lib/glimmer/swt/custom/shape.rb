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

module Glimmer
  module SWT
    module Custom
      # Represents a shape (graphics) to be drawn on a control/widget/canvas/display
      # swt_widget returns the parent (e.g. a `canvas` WidgetProxy), equivalent to `parent.swt_widget`
      # That is because Shape is drawn on a parent as graphics and doesn't have an SWT widget for itself
      class Shape
        include Packages
        include Properties
        # TODO support textExtent sized shapes nested within text/string
        # TODO support a Pattern DSL for methods that take Pattern arguments
        
        class << self
          def valid?(parent, keyword, *args, &block)
            gc_instance_methods.include?(method_name(keyword, args))
          end
          
          def gc_instance_methods
            org.eclipse.swt.graphics.GC.instance_methods.map(&:to_s)
          end
          
          def arg_options(args, extract: false)
            arg_options_method = extract ? :pop : :last
            options = args.send(arg_options_method) if args.last.is_a?(Hash)
            options.nil? ? {} : options.symbolize_keys
          end
          
          def method_name(keyword, args)
            keyword = keyword.to_s
            gradient = 'gradient_' if arg_options(args)[:gradient]
            round = 'round_' if arg_options(args)[:round]
            gc_instance_method_name_prefix = !['polyline', 'point', 'image', 'focus'].include?(keyword) && (arg_options(args)[:fill] || arg_options(args)[:gradient]) ? 'fill_' : 'draw_'
            "#{gc_instance_method_name_prefix}#{gradient}#{round}#{keyword}"
          end
        end
        
        attr_reader :parent, :name, :args, :options, :swt_widget, :paint_listener_proxy
        
        def initialize(parent, keyword, *args, &property_block)
          @parent = parent
          @name = keyword
          @method_name = self.class.method_name(keyword, args)
          @options = self.class.arg_options(args, extract: true)
          @args = args
          @swt_widget = parent.respond_to?(:swt_display) ? parent.swt_display : parent.swt_widget
          @properties = {}
          @parent.shapes << self
          post_add_content if property_block.nil?
        end
        
        def draw?
          !fill?
        end
        
        def fill?
          @options[:fill]
        end
        
        def gradient?
          @options[:gradient]
        end
        
        def round?
          @options[:round]
        end
        
        def post_add_content
          event_handler = lambda do |event|
            @properties['background'] = [@parent.background] if fill? && !@properties.keys.map(&:to_s).include?('background')
            @properties['foreground'] = [@parent.foreground] if draw? && !@properties.keys.map(&:to_s).include?('foreground')
            @properties.each do |property, args|
              method_name = attribute_setter(property)
              apply_property_arg_conversions(method_name, args)
              event.gc.send(method_name, *args)
            end
            apply_shape_arg_conversions(@method_name, @args)
            apply_shape_arg_defaults(@method_name, @args)
            tolerate_shape_extra_args(@method_name, @args)
            event.gc.send(@method_name, *@args)
          end
          if parent.respond_to?(:swt_display)
            @paint_listener_proxy = @parent.on_swt_paint(&event_handler)
          else
            @paint_listener_proxy = @parent.on_paint_control(&event_handler)
          end
        end
        
        def apply_property_arg_conversions(method_name, args)
          the_java_method = org.eclipse.swt.graphics.GC.java_class.declared_instance_methods.detect {|m| m.name == method_name}
          if (args.first.is_a?(Symbol) || args.first.is_a?(String))
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
          if args.first.is_a?(Hash) && the_java_method.parameter_types.first == Font.java_class
            args[0] = FontProxy.new(args[0])
          end
          if args.first.is_a?(FontProxy)
            args[0] = args[0].swt_font
          end
          if ['setBackgroundPattern', 'setForegroundPattern'].include?(method_name.to_s)
            args.each_with_index do |arg, i|
              if arg.is_a?(Symbol) || arg.is_a?(String)
                args[i] = ColorProxy.new(arg).swt_color
              elsif arg.is_a?(ColorProxy)
                args[i] = arg.swt_color
              end
            end
            new_args = [DisplayProxy.instance.swt_display] + args
            args[0] = org.eclipse.swt.graphics.Pattern.new(*new_args)
            args[1..-1] = []
          end
        end
        
        def apply_shape_arg_conversions(method_name, args)
          if args.size > 1 && (method_name.include?('polygon') || method_name.include?('polyline'))
            args[0] = args.dup
            args[1..-1] = []
          end
        end
        
        def apply_shape_arg_defaults(method_name, args)
          if method_name.include?('round_rectangle') && args.size.between?(4, 5)
            (6 - args.size).times {args << 60}
          elsif method_name.include?('rectangle') && gradient? && args.size == 4
            args << true
          elsif (method_name.include?('text') || method_name.include?('string')) && !@properties.keys.map(&:to_s).include?('background') && args.size == 3
            args << true
          end
          if method_name.include?('image') && args.first.is_a?(String)
            args[0] = ImageProxy.new(args[0])
          end
          if method_name.include?('image') && args.first.is_a?(ImageProxy)
            args[0] = args[0].swt_image
          end
        end
                
        # Tolerates shape extra args added by user by mistake
        # (e.g. happens when switching from round rectangle to a standard one without removing all extra args)
        def tolerate_shape_extra_args(method_name, args)
          the_java_method_arg_count = org.eclipse.swt.graphics.GC.java_class.declared_instance_methods.select do |m|
            m.name == method_name.camelcase(:lower)
          end.map(&:parameter_types).map(&:size).max
          if args.size > the_java_method_arg_count
            args[the_java_method_arg_count..-1] = []
          end
        end
                
        def has_attribute?(attribute_name, *args)
          self.class.gc_instance_methods.include?(attribute_setter(attribute_name))
        end
  
        def set_attribute(attribute_name, *args)
          @properties[attribute_name] = args
        end
  
        def get_attribute(attribute_name)
          @properties.symbolize_keys[attribute_name.to_s.to_sym]
        end
    
      end
      
    end
    
  end
  
end
