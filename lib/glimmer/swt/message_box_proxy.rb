require 'glimmer/swt/swt_proxy'
require 'glimmer/swt/widget_proxy'
require 'glimmer/swt/display_proxy'
require 'glimmer/swt/shell_proxy'

module Glimmer
  module SWT
    # Proxy for org.eclipse.swt.widgets.Shell
    #
    # Follows the Proxy Design Pattern
    class MessageBoxProxy
      include_package 'org.eclipse.swt.widgets'
      
      attr_reader :swt_widget
      
      def initialize(parent, style)
        if parent.nil?
          @temporary_parent = parent = Glimmer::SWT::ShellProxy.new.swt_widget
        end
        @swt_widget = MessageBox.new(parent, style)        
      end
      
      def open
        @swt_widget.open.tap do |result|
          @temporary_parent&.dispose
        end
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
        @swt_widget.send(attribute_setter(attribute_name), *args) unless @swt_widget.send(attribute_getter(attribute_name)) == args.first
      end

      def get_attribute(attribute_name)
        @swt_widget.send(attribute_getter(attribute_name))
      end
      
      def method_missing(method, *args, &block)
        swt_widget.send(method, *args, &block)
      rescue => e
        Glimmer::Config.logger.debug {"Neither MessageBoxProxy nor #{swt_widget.class.name} can handle the method ##{method}"}
        super
      end
      
      def respond_to?(method, *args, &block)
        super || 
          swt_widget.respond_to?(method, *args, &block)
      end      
    end
  end
end
