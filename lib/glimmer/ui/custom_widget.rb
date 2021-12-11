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
require 'glimmer/ui'
require 'glimmer/error'
require 'glimmer/swt/swt_proxy'
require 'glimmer/swt/display_proxy'
require 'glimmer/util/proc_tracker'
require 'glimmer/data_binding/observer'
require 'glimmer/data_binding/observable_model'

module Glimmer
  module UI
    module CustomWidget
      include SuperModule
      include DataBinding::ObservableModel

      super_module_included do |klass|
        # TODO clear memoization of WidgetProxy.swt_widget_class_for for a keyword if a custom widget was defined with that keyword
        klass.include(Glimmer) unless klass.name.include?('Glimmer::UI::CustomShell')
        Glimmer::UI::CustomWidget.add_custom_widget_namespaces_for(klass) unless klass.name.include?('Glimmer::UI::CustomShell')
      end

      class << self
        def for(underscored_custom_widget_name)
          unless flyweight_custom_widget_classes.keys.include?(underscored_custom_widget_name)
            begin
              extracted_namespaces = underscored_custom_widget_name.
                to_s.
                split(/__/).map do |namespace|
                  namespace.camelcase(:upper)
                end
              custom_widget_namespaces.each do |base|
                extracted_namespaces.reduce(base) do |result, namespace|
                  if !result.constants.include?(namespace)
                    namespace = result.constants.detect {|c| c.to_s.upcase == namespace.to_s.upcase } || namespace
                  end
                  begin
                    flyweight_custom_widget_classes[underscored_custom_widget_name] = constant = result.const_get(namespace)
                    return constant if constant.ancestors.include?(Glimmer::UI::CustomWidget)
                    flyweight_custom_widget_classes[underscored_custom_widget_name] = constant
                  rescue => e
                    # Glimmer::Config.logger.debug {"#{e.message}\n#{e.backtrace.join("\n")}"}
                    flyweight_custom_widget_classes[underscored_custom_widget_name] = result
                  end
                end
              end
              raise "#{underscored_custom_widget_name} has no custom widget class!"
            rescue => e
              Glimmer::Config.logger.debug {e.message}
              Glimmer::Config.logger.debug {"#{e.message}\n#{e.backtrace.join("\n")}"}
              flyweight_custom_widget_classes[underscored_custom_widget_name] = nil
            end
          end
          flyweight_custom_widget_classes[underscored_custom_widget_name]
        end
        
        # Flyweight Design Pattern memoization cache. Can be cleared if memory is needed.
        def flyweight_custom_widget_classes
          @flyweight_custom_widget_classes ||= {}
        end
        
        # Returns keyword to use for this custom widget
        def keyword
          self.name.underscore.gsub('::', '__')
        end
        
        # Returns shortcut keyword to use for this custom widget (keyword minus namespace)
        def shortcut_keyword
          self.name.underscore.gsub('::', '__').split('__').last
        end
        
        def add_custom_widget_namespaces_for(klass)
          Glimmer::UI::CustomWidget.namespaces_for_class(klass).drop(1).each do |namespace|
            Glimmer::UI::CustomWidget.custom_widget_namespaces << namespace
          end
        end

        def namespaces_for_class(m)
          return [m] if m.name.nil?
          namespace_constants = m.name.split(/::/).map(&:to_sym)
          namespace_constants.reduce([Object]) do |output, namespace_constant|
            output += [output.last.const_get(namespace_constant)]
          end[1..-1].uniq.reverse
        end

        def custom_widget_namespaces
          @custom_widget_namespaces ||= reset_custom_widget_namespaces
        end

        def reset_custom_widget_namespaces
          @custom_widget_namespaces = Set[Object, Glimmer::UI]
        end

        # Allows defining convenience option accessors for an array of option names
        # Example: `options :color1, :color2` defines `#color1` and `#color2`
        # where they return the instance values `options[:color1]` and `options[:color2]`
        # respectively.
        # Can be called multiple times to set more options additively.
        # When passed no arguments, it returns list of all option names captured so far
        def options(*new_options)
          new_options = new_options.compact.map(&:to_s).map(&:to_sym)
          if new_options.empty?
            @options ||= {} # maps options to defaults
          else
            new_options = new_options.reduce({}) {|new_options_hash, new_option| new_options_hash.merge(new_option => nil)}
            @options = options.merge(new_options)
            def_option_attr_accessors(new_options)
          end
        end

        def option(new_option, default: nil)
          new_option = new_option.to_s.to_sym
          new_options = {new_option => default}
          @options = options.merge(new_options)
          def_option_attr_accessors(new_options)
        end

        def def_option_attr_accessors(new_options)
          new_options.each do |option, default|
            class_eval <<-end_eval, __FILE__, __LINE__
              def #{option}
                options[:#{option}]
              end
              def #{option}=(option_value)
                self.options[:#{option}] = option_value
              end
            end_eval
          end
        end

        def before_body(&block)
          @before_body_block = block
        end

        def body(&block)
          @body_block = block
        end

        def after_body(&block)
          @after_body_block = block
        end

        # Current custom widgets being rendered. Useful to yoke all observers evaluated during rendering of their custom widgets for automatical disposal on_widget_disposed
        def current_custom_widgets
          @current_custom_widgets ||= []
        end
      end

      attr_reader :body_root, :swt_widget, :parent, :parent_proxy, :swt_style, :options

      def initialize(parent, *swt_constants, options, &content)
        Glimmer::UI::CustomWidget.current_custom_widgets << self
        @parent_proxy = @parent = parent
        @parent_proxy = @parent&.get_data('proxy') if @parent.respond_to?(:get_data) && @parent.get_data('proxy')
        @swt_style = SWT::SWTProxy[*swt_constants]
        options ||= {}
        @options = self.class.options.merge(options)
        @content = Util::ProcTracker.new(content) if content
        auto_exec { execute_hook('before_body') }
        body_block = self.class.instance_variable_get("@body_block")
        raise Glimmer::Error, 'Invalid custom widget for having no body! Please define body block!' if body_block.nil?
        @body_root = auto_exec { instance_exec(&body_block) }
        raise Glimmer::Error, 'Invalid custom widget for having an empty body! Please fill body block!' if @body_root.nil?
        @swt_widget = @body_root.swt_widget
        auto_exec do
          @swt_widget.set_data('custom_widget', self)
        end
        auto_exec { execute_hook('after_body') }
        auto_exec do
          @dispose_listener_registration = @body_root.on_widget_disposed do
            unless @body_root.shell_proxy.last_shell_closing?
              observer_registrations.compact.each(&:deregister)
              observer_registrations.clear
            end
          end
        end
        post_add_content if content.nil?
      end
      
      # Subclasses may override to perform post initialization work on an added child
      def post_initialize_child(child)
        # No Op by default
      end

      def post_add_content
        Glimmer::UI::CustomWidget.current_custom_widgets.delete(self)
      end
      
      def observer_registrations
        @observer_registrations ||= []
      end

      def can_handle_observation_request?(observation_request)
        observation_request = observation_request.to_s
        result = false
        if observation_request.start_with?('on_updated_')
          property = observation_request.sub(/^on_updated_/, '')
          result = can_add_observer?(property)
        end
        result || body_root&.can_handle_observation_request?(observation_request)
      end

      def handle_observation_request(observation_request, &block)
        observation_request = observation_request.to_s
        if observation_request.start_with?('on_updated_')
          property = observation_request.sub(/^on_updated_/, '') # TODO look into eliminating duplication from above
          add_observer(DataBinding::Observer.proc(&block), property) if can_add_observer?(property)
        else
          body_root.handle_observation_request(observation_request, &block)
        end
      end

      def can_add_observer?(attribute_name)
        has_instance_method?(attribute_name) || has_instance_method?("#{attribute_name}?") || @body_root.can_add_observer?(attribute_name)
      end

      def add_observer(observer, attribute_name)
        if has_instance_method?(attribute_name)
          super
        else
          @body_root.add_observer(observer, attribute_name)
        end
      end

      def has_attribute?(attribute_name, *args)
        has_instance_method?(attribute_setter(attribute_name)) ||
          @body_root.has_attribute?(attribute_name, *args)
      end

      def set_attribute(attribute_name, *args)
        if has_instance_method?(attribute_setter(attribute_name))
          send(attribute_setter(attribute_name), *args)
        else
          @body_root.set_attribute(attribute_name, *args)
        end
      end

      # This method ensures it has an instance method not coming from Glimmer DSL
      def has_instance_method?(method_name)
        respond_to?(method_name) and
          !swt_widget&.respond_to?(method_name) and
          (method(method_name) rescue nil) and
          !method(method_name)&.source_location&.first&.include?('glimmer/dsl/engine.rb') and
          !method(method_name)&.source_location&.first&.include?('glimmer/swt/widget_proxy.rb')
      end

      def get_attribute(attribute_name)
        if has_instance_method?(attribute_name)
          send(attribute_name)
        else
          @body_root.get_attribute(attribute_name)
        end
      end

      def attribute_setter(attribute_name)
        "#{attribute_name}="
      end
      
      def disposed?
        swt_widget.isDisposed
      end

      def has_style?(style)
        (swt_style & SWT::SWTProxy[style]) == SWT::SWTProxy[style]
      end
      
      # TODO see if it is worth it to eliminate duplication of async_exec/sync_exec
      # delegation to DisplayProxy, via a module

      def async_exec(&block)
        SWT::DisplayProxy.instance.async_exec(&block)
      end

      def sync_exec(&block)
        SWT::DisplayProxy.instance.sync_exec(&block)
      end

      def timer_exec(delay_in_millis, &block)
        SWT::DisplayProxy.instance.timer_exec(delay_in_millis, &block)
      end

      # Returns content block if used as an attribute reader (no args)
      # Otherwise, if a block is passed, it adds it as content to this custom widget
      def content(&block)
        if block_given?
          Glimmer::DSL::Engine.add_content(self, Glimmer::DSL::SWT::CustomWidgetExpression.new, self.class.keyword, &block)
        else
          @content
        end
      end

      def method_missing(method, *args, &block)
        # TODO Consider supporting a glimmer error silencing option for methods defined here
        # but fail the glimmer DSL for the right reason to avoid seeing noise in the log output
        if can_handle_observation_request?(method)
          handle_observation_request(method, &block)
        else
          body_root.send(method, *args, &block)
        end
      end

      alias local_respond_to? respond_to?
      def respond_to?(method, *args, &block)
        super or
          can_handle_observation_request?(method) or
          body_root.respond_to?(method, *args, &block)
      end
      
      private

      def execute_hook(hook_name)
        hook_block = self.class.instance_variable_get("@#{hook_name}_block")
        return if hook_block.nil?
        temp_method_name = "#{hook_name}_block_#{hook_block.hash.abs}_#{(Time.now.to_f * 1_000_000).to_i}"
        singleton_class.define_method(temp_method_name, &hook_block)
        send(temp_method_name)
        singleton_class.send(:remove_method, temp_method_name)
      end
    end
  end
end
