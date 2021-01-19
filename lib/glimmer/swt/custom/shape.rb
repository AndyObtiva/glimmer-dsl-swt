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

module Glimmer
  module SWT
    module Custom
      # Represents a shape (graphics) to be drawn on a control/widget/canvas/display
      # swt_widget returns the parent (e.g. a `canvas` WidgetProxy), equivalent to `parent.swt_widget`
      # That is because Shape is drawn on a parent as graphics and doesn't have an SWT widget for itself
      class Shape
        include Properties
        # TODO support textExtent as an option
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
            gc_instance_method_name_prefix = arg_options(args)[:fill] ? 'fill_' : 'draw_'
            "#{gc_instance_method_name_prefix}#{keyword}"
          end
        end
        
        attr_reader :parent, :name, :args, :options, :swt_widget, :paint_listener_proxy
        
        def initialize(parent, keyword, *args)
          @parent = parent
          @name = keyword
          @method_name = self.class.method_name(keyword, args)
          @options = self.class.arg_options(args, extract: true)
          @args = args
          @swt_widget = parent.respond_to?(:swt_display) ? parent.swt_display : parent.swt_widget
          @properties = {}
          @parent.shapes << self
        end
        
        def fill?
          !draw?
        end
        
        def draw?
          !@options[:fill]
        end
        
        def post_add_content
          event_handler = lambda do |event|
            @properties.each do |property, args|
              method_name = attribute_setter(property)
              handle_conversions(method_name, args)
              event.gc.send(method_name, *args)
            end
            event.gc.send(@method_name, *@args)
          end
          if parent.respond_to?(:swt_display)
            @paint_listener_proxy = @parent.on_swt_paint(&event_handler)
          else
            @paint_listener_proxy = @parent.on_paint_control(&event_handler)
          end
        end
        
        def handle_conversions(method_name, args)
          the_java_method = org.eclipse.swt.graphics.GC.java_class.declared_instance_methods.detect {|m| m.name == method_name}
          if args.first.is_a?(Symbol) || args.first.is_a?(String)
            if the_java_method.parameter_types.first == Color.java_class
              args[0] = ColorProxy.new(args[0])
            end
          end
          if args.first.is_a?(ColorProxy)
            args[0] = args[0].swt_color
          end
          if args.first.is_a?(Hash)
            if the_java_method.parameter_types.first == Font.java_class
              args[0] = FontProxy.new(args[0])
            end
          end
          if args.first.is_a?(FontProxy)
            args[0] = args[0].swt_font
          end
          
          # TODO convert SWT style symbol to integer if method takes integer
        end
        
        def has_attribute?(attribute_name, *args)
          # TODO test that attribute getter responds too
          self.class.gc_instance_methods.include?(attribute_setter(attribute_name))
        end
  
        def set_attribute(attribute_name, *args)
          # TODO special treatment for color symbols
          @properties[attribute_name] = args
        end
  
        def get_attribute(attribute_name)
          @properties.symbolize_keys[attribute_name.to_s.to_sym]
        end
    
      end
      
    end
    
  end
  
end
