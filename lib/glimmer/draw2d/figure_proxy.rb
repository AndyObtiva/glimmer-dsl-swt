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

module Glimmer
  module Draw2d
    class FigureProxy
      include Glimmer::SWT::Packages
      include Glimmer::SWT::ProxyProperties
      
      class << self
        def create(*init_args)
          parent, keyword, args = init_args
          figure_proxy_class(keyword).new(*init_args)
        end
        
        def figure_proxy_class(keyword)
          begin
            class_name = "#{keyword.to_s.camelcase(:upper)}Proxy".to_sym
            Glimmer::Draw2d.const_get(class_name)
          rescue
            Glimmer::Draw2d::FigureProxy
          end
        end
        
        def underscored_figure_name(draw2d_figure)
          draw2d_figure.class.name.split(/::|\./).last.underscore
        end
        
        def valid?(keyword)
          !!draw2d_figure_class_for(keyword)
        end
        
        def draw2d_figure_class_for(keyword)
          unless flyweight_draw2d_figure_classes.keys.include?(keyword)
            begin
              draw2d_figure_name = keyword.camelcase(:upper)
              draw2d_figure_class = eval(draw2d_figure_name)
              unless draw2d_figure_class.ancestors.include?(org.eclipse.swt.widgets.Widget)
                if draw2d_figure_class.nil?
                  Glimmer::Config.logger.debug {"Class #{draw2d_figure_class} matching #{keyword} is not a subclass of org.eclipse.swt.widgets.Widget"}
                  return nil
                end
              end
              flyweight_draw2d_figure_classes[keyword] = draw2d_figure_class
            rescue SyntaxError, NameError => e
              Glimmer::Config.logger.debug {e.full_message}
              nil
            rescue => e
              Glimmer::Config.logger.debug {e.full_message}
              nil
            end
          end
          flyweight_draw2d_figure_classes[keyword]
        end
        
        def flyweight_draw2d_figure_classes
          @flyweight_draw2d_figure_classes ||= {}
        end
        
      end

      attr_reader :parent_proxy, :draw2d_figure, :finished_add_content, :lightweight_system, :keyword, :top_level_figure
      alias finished_add_content? finished_add_content
      
      # Initializes a new SWT Widget
      #
      # It is preferred to use `::create` method instead since it instantiates the
      # right subclass per widget keyword
      #
      def initialize(*init_args)
        @parent_proxy, @keyword, @args = init_args
        @args = init_args.drop(2)
        @keyword = @keyword.to_s
        draw2d_figure_class = self.class.draw2d_figure_class_for(keyword)
        @lightweight_system = @parent_proxy.lightweight_system
        @top_level_figure = @parent_proxy.top_level_figure
        @parent_figure = @parent_proxy.is_a?(FigureProxy) ? @parent_proxy : @parent_proxy.top_level_figure
        @draw2d_figure = draw2d_figure_class.new(*@args)
        @parent_figure.add(@draw2d_figure)
      end
      
      # Subclasses may override to perform post initialization work on an added child
      def post_initialize_child(child)
        # No Op by default
      end

      # Subclasses may override to perform post add_content work.
      # Make sure its logic detects if it ran before since it could run multiple times
      # when adding content multiple times post creation.
      def post_add_content
        # No Op by default
      end
      
      def finish_add_content!
        @finished_add_content = true
      end
      
      def proxy_source_object
        @draw2d_figure
      end
      
      def x
        bounds.x
      end

      def y
        bounds.y
      end
      
      def width
        bounds.width
      end

      def height
        bounds.height
      end



      def can_handle_observation_request?(observation_request)
        if observation_request.to_s.start_with?('on_')
          event = observation_request.sub(/^on_/, '')
          can_add_listener?(event)
        end
      end
      
      def handle_observation_request(observation_request, &block)
        if observation_request.to_s.start_with?('on_')
          event = observation_request.sub(/^on_/, '')
          if can_add_listener?(event)
            event = observation_request.sub(/^on_/, '')
            add_listener(event, &block)
          end
        end
      end

      def content(&block)
        Glimmer::DSL::Engine.add_content(self, Glimmer::DSL::SWT::FigureExpression.new, @keyword, &block)
      end

      def method_missing(method, *args, &block)
        # TODO push most of this logic down to Properties (and perhaps create Listeners module as well)
        if can_handle_observation_request?(method)
          handle_observation_request(method, &block)
        else
          super
        end
      end
      
      def respond_to?(method, *args, &block)
        result = super
        return true if result
        can_handle_observation_request?(method)
      end
      
      private

      def style(underscored_widget_name, styles)
        styles = [styles].flatten.compact
        styles = default_style(underscored_widget_name) if styles.empty?
        interpret_style(*styles)
      end
      
      def interpret_style(*styles)
        SWTProxy[*styles] rescue DNDProxy[*styles]
      end

      def default_style(underscored_widget_name)
        DEFAULT_STYLES[underscored_widget_name] || [:none]
      end

      # TODO refactor following methods to eliminate duplication
      # perhaps consider relying on raising an exception to avoid checking first
      # unless that gives obscure SWT errors
      # Otherwise, consider caching results from can_add_lsitener and using them in
      # add_listener knowing it will be called for sure afterwards

      def can_add_listener?(underscored_listener_name)
        !self.class.find_listener(@draw2d_figure.getClass, underscored_listener_name).empty?
      end

      def add_listener(underscored_listener_name, &block)
        widget_add_listener_method, listener_class, listener_method = self.class.find_listener(@draw2d_figure.getClass, underscored_listener_name)
        widget_listener_proxy = nil
        safe_block = lambda do |*args|
          begin
            block.call(*args)
          rescue => e
            Glimmer::Config.logger.error {e}
          end
        end
        listener = listener_class.new(listener_method => safe_block)
        @draw2d_figure.send(widget_add_listener_method, listener)
        Glimmer::SWT::WidgetListenerProxy.new(swt_widget: @draw2d_figure, swt_listener: listener, widget_add_listener_method: widget_add_listener_method, swt_listener_class: listener_class, swt_listener_method: listener_method)
      end

      def self.find_listener(swt_widget_class, underscored_listener_name)
        @listeners ||= {}
        listener_key = [swt_widget_class.name, underscored_listener_name]
        unless @listeners.has_key?(listener_key)
          listener_method_name = underscored_listener_name.camelcase(:lower)
          swt_widget_class.getMethods.each do |widget_add_listener_method|
            if widget_add_listener_method.getName.match(/add.*Listener/)
              widget_add_listener_method.getParameterTypes.each do |listener_type|
                listener_type.getMethods.each do |listener_method|
                  if (listener_method.getName == listener_method_name)
                    @listeners[listener_key] = [widget_add_listener_method.getName, listener_class(listener_type), listener_method.getName]
                    return @listeners[listener_key]
                  end
                end
              end
            end
          end
          @listeners[listener_key] = []
        end
        @listeners[listener_key]
      end

      # Returns a Ruby class that implements listener type Java interface with ability to easily
      # install a block that gets called upon calling a listener event method
      def self.listener_class(listener_type)
        @listener_classes ||= {}
        listener_class_key = listener_type.name
        unless @listener_classes.has_key?(listener_class_key)
          @listener_classes[listener_class_key] = Class.new(Object).tap do |listener_class|
            listener_class.send :include, (eval listener_type.name.sub("interface", ""))
            listener_class.define_method('initialize') do |event_method_block_mapping|
              @event_method_block_mapping = event_method_block_mapping
            end
            listener_type.getMethods.each do |event_method|
              listener_class.define_method(event_method.getName) do |*args|
                @event_method_block_mapping[event_method.getName]&.call(*args)
              end
            end
          end
        end
        @listener_classes[listener_class_key]
      end

    end
    
  end
  
end
