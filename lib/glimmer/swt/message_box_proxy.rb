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

require 'glimmer/swt/swt_proxy'
require 'glimmer/swt/widget_proxy'
require 'glimmer/swt/display_proxy'
require 'glimmer/swt/shell_proxy'

module Glimmer
  module SWT
    # Proxy for org.eclipse.swt.widgets.MessageBox
    #
    # Follows the Proxy Design Pattern
    class MessageBoxProxy
      include_package 'org.eclipse.swt.widgets'
      
      attr_reader :swt_widget
      
      def initialize(parent, style)
        # TODO consider consolidating with DialogProxy if it makes sense
        if parent.nil?
          @temporary_parent = parent = Glimmer::SWT::ShellProxy.new.swt_widget
        end
        @swt_widget = MessageBox.new(parent, style)
      end
      
      def open
        DisplayProxy.instance.auto_exec do
          @swt_widget.open.tap do |result|
            @temporary_parent&.dispose
          end
        end
      end
      
      def content(&block)
        Glimmer::DSL::Engine.add_content(self, Glimmer::DSL::SWT::MessageBoxExpression.new, 'message_box', &block)
      end
      
      # TODO refactor the following methods to put in a JavaBean mixin or somethin (perhaps contribute to OSS project too)
      
      def attribute_setter(attribute_name)
        "set#{attribute_name.to_s.camelcase(:upper)}"
      end

      def attribute_getter(attribute_name)
        "get#{attribute_name.to_s.camelcase(:upper)}"
      end
      
      def has_attribute?(attribute_name, *args)
        @swt_widget.respond_to?(attribute_setter(attribute_name), args)
      end

      def set_attribute(attribute_name, *args)
        DisplayProxy.instance.auto_exec do
          @swt_widget.send(attribute_setter(attribute_name), *args) unless @swt_widget.send(attribute_getter(attribute_name)) == args.first
        end
      end

      def get_attribute(attribute_name)
        DisplayProxy.instance.auto_exec do
          @swt_widget.send(attribute_getter(attribute_name))
        end
      end
      
      def method_missing(method, *args, &block)
        DisplayProxy.instance.auto_exec do
          swt_widget.send(method, *args, &block)
        end
      rescue => e
        begin
          super
        rescue Exception => inner_error
          Glimmer::Config.logger.error {"Neither MessageBoxProxy nor #{swt_widget.class.name} can handle the method ##{method}"}
          Glimmer::Config.logger.error {e.full_message}
          raise inner_error
        end
      end
      
      def respond_to?(method, *args, &block)
        super ||
          swt_widget.respond_to?(method, *args, &block)
      end
    end
  end
end
