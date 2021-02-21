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

require 'glimmer/swt/widget_listener_proxy'
require 'glimmer/swt/custom/drawable'

module Glimmer
  module SWT
    # Proxy for org.eclipse.swt.widgets.Display
    #
    # Maintains a singleton instance since SWT only supports
    # a single active display at a time.
    #
    # Supports SWT Display's very useful asyncExec and syncExec methods
    # to support proper multi-threaded manipulation of SWT UI objects
    #
    # Invoking `#swt_display` returns the SWT Display object wrapped by this proxy
    #
    # Follows the Proxy Design Pattern
    class DisplayProxy
      include_package 'org.eclipse.swt.widgets'
      
      include Custom::Drawable
      
      OBSERVED_MENU_ITEMS = ['about', 'preferences', 'quit']
      
      class FilterListener
        include org.eclipse.swt.widgets.Listener
        
        def initialize(&listener_block)
          @listener_block = listener_block
        end
        
        def handleEvent(event)
          @listener_block.call(event)
        end
      end

      class << self
        # Returns singleton instance
        def instance(*args)
          if @instance.nil? || @instance.swt_display.nil? || @instance.swt_display.isDisposed
            @thread = Thread.current
            @instance = new(*args)
          end
          @instance
        end
        
        def thread
          instance # ensure instance
          @thread
        end
      end

      # SWT Display object wrapped
      attr_reader :swt_display

      def initialize(*args)
        Display.app_name ||= 'Glimmer'
        @swt_display = Display.new(*args)
        @swt_display.set_data('proxy', self)
        @execs_in_progress = []
        on_swt_Dispose {
          clear_shapes
        }
      end
      
      def content(&block)
        Glimmer::DSL::Engine.add_content(self, Glimmer::DSL::SWT::DisplayExpression.new, &block)
      end
      
      # asynchronously executes the block (required from threads other than first GUI thread)
      # does not return the value produced by the block since it is async, running after the return
      def async_exec(&block)
        @swt_display.asyncExec do
          @execs_in_progress << :async_exec
          block.call
          @execs_in_progress.pop
        end
      end

      # synchronously executes the block (required from threads other than first GUI thread)
      # returns the value produced by the block
      def sync_exec(&block)
        result = nil
        @swt_display.syncExec do
          @execs_in_progress << :sync_exec
          result = block.call
          @execs_in_progress.pop
        end
        result
      end

      def timer_exec(delay_in_millis, &block)
        @swt_display.timerExec(delay_in_millis, &block)
      end
      
      # Indicates whether `sync_exec` is required because of running in a different thread from the GUI thread
      # `async_exec` could be used as an alternative to `sync_exec` when required.
      def sync_exec_required?
        Thread.current != DisplayProxy.thread
      end
      
      def async_exec_in_progress?
        @execs_in_progress.last == :async_exec
      end
      
      def sync_exec_in_progress?
        @execs_in_progress.include?(:sync_exec)
      end
      
      # Invoke block with `sync_exec` only when necessary (running from a separate thread)
      # Override sync_exec as `true` to force using or `false` to force avoiding
      # Override async_exec as `true` to force using or `:unless_in_progress` to force using only if no `async_exec` is in progress
      # Disable auto execution of `sync_exec` via `Glimmer::Config.auto_sync_exec = false`
      # Otherwise, runs normally, thus allowing SWT to decide how to batch/optimize GUI updates
      def auto_exec(override_sync_exec: nil, override_async_exec: nil, &block)
        if override_sync_exec || override_sync_exec.nil? && !override_async_exec && sync_exec_required? && Config.auto_sync_exec? && !sync_exec_in_progress? && !async_exec_in_progress?
          sync_exec(&block)
        elsif override_async_exec || override_async_exec.to_s == 'unless_in_progress' && !async_exec_in_progress?
          async_exec(&block)
        else
          block.call
        end
      end

      def on_widget_disposed(&block)
        on_swt_Dispose(&block)
      end
      
      def disposed?
        @swt_display.isDisposed
      end

      def method_missing(method, *args, &block)
        if can_handle_observation_request?(method)
          handle_observation_request(method, &block)
        else
          swt_display.send(method, *args, &block)
        end
      rescue => e
        Glimmer::Config.logger.debug {"Neither DisplayProxy nor #{swt_display.class.name} can handle the method ##{method}"}
        super
      end
      
      def respond_to?(method, *args, &block)
        super ||
          can_handle_observation_request?(method) ||
          swt_display.respond_to?(method, *args, &block)
      end

      def can_handle_observation_request?(observation_request)
        observation_request = observation_request.to_s
        if observation_request.start_with?('on_swt_')
          constant_name = observation_request.sub(/^on_swt_/, '')
          SWTProxy.has_constant?(constant_name)
        elsif observation_request.start_with?('on_')
          event_name = observation_request.sub(/^on_/, '')
          OBSERVED_MENU_ITEMS.include?(event_name)
        else
          false
        end
      end

      def handle_observation_request(observation_request, &block)
        observation_request = observation_request.to_s
        if observation_request.start_with?('on_swt_')
          constant_name = observation_request.sub(/^on_swt_/, '')
          add_swt_event_filter(constant_name, &block)
        elsif observation_request.start_with?('on_')
          event_name = observation_request.sub(/^on_/, '')
          if OBSERVED_MENU_ITEMS.include?(event_name) && OS.mac?
            system_menu = swt_display.getSystemMenu
            menu_item = system_menu.getItems.find {|menu_item| menu_item.getID == SWTProxy["ID_#{event_name.upcase}"]}
            display_mac_event_registration = menu_item.addListener(SWTProxy[:Selection], &block)
            # TODO enable this code and test on the Mac to ensure automatic cleanup of mac event registrations in custom widgets
#             Glimmer::UI::CustomWidget.current_custom_widgets.last&.observer_registrations&.push(display_mac_event_registration)
            display_mac_event_registration
          end
        end
      end

      def add_swt_event_filter(swt_constant, &block)
        event_type = SWTProxy[swt_constant]
        @swt_display.addFilter(event_type, FilterListener.new(&block))
        #WidgetListenerProxy.new(@swt_display.getListeners(event_type).last)
        WidgetListenerProxy.new(
          swt_display: @swt_display,
          event_type: event_type,
          filter: true,
          swt_listener: block,
          widget_add_listener_method: 'addFilter',
          swt_listener_class:  FilterListener,
          swt_listener_method: 'handleEvent'
        )
      end
    end
  end
end
