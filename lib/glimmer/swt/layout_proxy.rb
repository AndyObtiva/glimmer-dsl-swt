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

require 'glimmer'
require 'glimmer/swt/swt_proxy'

module Glimmer
  module SWT
    # Proxy for org.eclipse.swt.widgets.Layout
    #
    # This is meant to be used with a WidgetProxy where it will
    # set the layout in the SWT widget upon instantiation.
    #
    # Follows the Proxy Design Pattern
    class LayoutProxy
      attr_reader :widget_proxy, :swt_layout

      class << self
        include_package 'org.eclipse.swt.layout'
        include_package 'org.eclipse.swt.widgets'

        def layout_exists?(underscored_layout_name)
          begin
            swt_layout_class_for(underscored_layout_name)
            true
          rescue NameError => e
            false
          end
        end

        # This supports layouts in and out of basic SWT library
        def swt_layout_class_for(underscored_layout_name)
          swt_layout_name = underscored_layout_name.camelcase(:upper)
          swt_layout_class = eval(swt_layout_name)
          unless swt_layout_class.ancestors.include?(Layout)
            raise NameError, "Class #{swt_layout_class} matching #{underscored_layout_name} is not a subclass of org.eclipse.swt.widgets.Layout"
          end
          swt_layout_class
        rescue => e
          Glimmer::Config.logger.debug {e.message}
          # Glimmer::Config.logger.debug {"#{e.message}\n#{e.backtrace.join("\n")}"}
          raise e
        end
      end

      def initialize(underscored_layout_name, widget_proxy, args)
        DisplayProxy.instance.auto_exec do
          @underscored_layout_name = underscored_layout_name
          @widget_proxy = widget_proxy
          args = SWTProxy.constantify_args(args)
          @swt_layout = self.class.swt_layout_class_for(underscored_layout_name).new(*args)
          @swt_layout.marginWidth = 15 if @swt_layout.respond_to?(:marginWidth)
          @swt_layout.marginHeight = 15 if @swt_layout.respond_to?(:marginHeight)
          @swt_layout.marginTop = 0 if @swt_layout.respond_to?(:marginTop)
          @swt_layout.marginRight = 0 if @swt_layout.respond_to?(:marginRight)
          @swt_layout.marginBottom = 0 if @swt_layout.respond_to?(:marginBottom)
          @swt_layout.marginLeft = 0 if @swt_layout.respond_to?(:marginLeft)
          old_layout = @widget_proxy.swt_widget.getLayout
          @widget_proxy.swt_widget.setLayout(@swt_layout)
          @widget_proxy.swt_widget.layout if old_layout
        end
      end

      def has_attribute?(attribute_name, *args)
        @swt_layout.respond_to?(attribute_setter(attribute_name), args)
      end

      def set_attribute(attribute_name, *args)
        DisplayProxy.instance.auto_exec do
          apply_property_type_converters(attribute_name, args)
          if args.first != @swt_layout.send(attribute_getter(attribute_name))
          @swt_layout.send(attribute_setter(attribute_name), *args)
          @widget_proxy.swt_widget.layout
          @widget_proxy.swt_widget.getShell.layout
          end
        end
      end

      def get_attribute(attribute_name)
        @swt_layout.send(attribute_getter(attribute_name))
      end

      def apply_property_type_converters(attribute_name, args)
        if args.count == 1 && SWTProxy.has_constant?(args.first)
          args[0] = SWTProxy.constant(args.first)
        end
      end

      def attribute_setter(attribute_name)
        "#{attribute_name.to_s.camelcase(:lower)}="
      end

      def attribute_getter(attribute_name)
        "#{attribute_name.to_s.camelcase(:lower)}"
      end
    end
  end
end
