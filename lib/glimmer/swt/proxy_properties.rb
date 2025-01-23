# Copyright (c) 2007-2025 Andy Maleh
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
    # Provides a default implementation for proxy properties, that is
    # properties that come from a proxy object source such as swt_widget
    # having Java camelcase format
    module ProxyProperties
      include Properties
      
      # Subclasses must override to privde a proxy source if they want to take advantage of
      # default implementation of attribute setters/getters
      # It tries swt_widget, swt_display, swt_image, and swt_dialog by default.
      def proxy_source_object
        # TODO the logic here should not be needed if derived with polymorphism. Consider removing.
        if respond_to?(:swt_widget)
          swt_widget
        elsif respond_to?(:swt_display)
          swt_display
        elsif respond_to?(:swt_image)
          swt_image
        elsif respond_to?(:swt_dialog)
          swt_dialog
        elsif respond_to?(:swt_transform)
          swt_transform
        end
      end
      
      def has_attribute_getter?(attribute_getter_name, *args)
        attribute_getter_name = attribute_getter_name.to_s.underscore
        return false unless !attribute_getter_name.end_with?('=') && !attribute_getter_name.start_with?('set_')
        args.empty? && proxy_source_object&.respond_to?(attribute_getter_name)
      end
      
      def has_attribute_setter?(attribute_setter_name, *args)
        attribute_setter_name = attribute_setter_name.to_s
        underscored_attribute_setter_name = attribute_setter_name.underscore
        return false unless attribute_setter_name.end_with?('=') || (attribute_setter_name.start_with?('set_') && !args.empty?)
        attribute_name = underscored_attribute_setter_name.sub(/^set_/, '').sub(/=$/, '')
        has_attribute?(attribute_name, *args)
      end

      def has_attribute?(attribute_name, *args)
        Glimmer::SWT::DisplayProxy.instance.auto_exec do
          proxy_source_object&.respond_to?(attribute_setter(attribute_name), args) or
            respond_to?(ruby_attribute_setter(attribute_name), args)
        end
      end
      
      def set_attribute(attribute_name, *args)
        swt_widget_operation = false
        result = nil
        Glimmer::SWT::DisplayProxy.instance.auto_exec do
          result = if proxy_source_object&.respond_to?(attribute_setter(attribute_name))
            swt_widget_operation = true
            proxy_source_object&.send(attribute_setter(attribute_name), *args) unless (proxy_source_object&.respond_to?(attribute_getter(attribute_name)) && proxy_source_object&.send(attribute_getter(attribute_name))) == args.first
          elsif proxy_source_object&.respond_to?(ruby_attribute_setter(attribute_name))
            swt_widget_operation = true
            proxy_source_object&.send(ruby_attribute_setter(attribute_name), args)
          end
        end
        unless swt_widget_operation
          result = send(ruby_attribute_setter(attribute_name), args) if respond_to?(ruby_attribute_setter(attribute_name), args)
        end
        result
      end

      def get_attribute(attribute_name)
        swt_widget_operation = false
        result = nil
        Glimmer::SWT::DisplayProxy.instance.auto_exec do
          result = if proxy_source_object&.respond_to?(attribute_getter(attribute_name))
            swt_widget_operation = true
            proxy_source_object&.send(attribute_getter(attribute_name))
          elsif proxy_source_object&.respond_to?(ruby_attribute_getter(attribute_name))
            swt_widget_operation = true
            proxy_source_object&.send(ruby_attribute_getter(attribute_name))
          elsif proxy_source_object&.respond_to?(attribute_name)
            swt_widget_operation = true
            proxy_source_object&.send(attribute_name)
          end
        end
        unless swt_widget_operation
          if respond_to?(ruby_attribute_getter(attribute_name))
            result = send(ruby_attribute_getter(attribute_name))
          elsif respond_to?(attribute_name)
            result = send(attribute_name)
          end
        end
        result
      end
      
      def method_missing(method, *args, &block)
        if has_attribute_setter?(method, *args)
          set_attribute(method, *args)
        elsif has_attribute_getter?(method, *args)
          get_attribute(method, *args)
        else
          Glimmer::SWT::DisplayProxy.instance.auto_exec do
            proxy_source_object&.send(method, *args, &block)
          end
        end
      rescue => e
        begin
          super
        rescue Exception => inner_error
          Glimmer::Config.logger.error { "Neither self.class.name nor #{proxy_source_object&.class.name} can handle the method ##{method}" }
          Glimmer::Config.logger.error { e.full_message }
          raise inner_error
        end
      end
      
      def respond_to?(method, *args, &block)
        result = super
        return true if result
        Glimmer::SWT::DisplayProxy.instance.auto_exec do
          proxy_source_object&.respond_to?(method, *args, &block)
        end
      end
      
    end
    
  end
  
end
