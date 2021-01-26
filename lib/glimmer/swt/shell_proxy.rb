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

module Glimmer
  module SWT
    # Proxy for org.eclipse.swt.widgets.Shell
    #
    # Follows the Proxy Design Pattern
    class ShellProxy < WidgetProxy
      include_package 'org.eclipse.swt.widgets'
      include_package 'org.eclipse.swt.layout'

      WIDTH_MIN = 130
      HEIGHT_MIN = 0

      attr_reader :opened_before
      alias opened_before? opened_before

      # Instantiates ShellProxy with same arguments expected by SWT Shell
      # if swt_widget keyword arg was passed, then it is assumed the shell has already been instantiated
      # and the proxy wraps it instead of creating a new one.
      def initialize(*args, swt_widget: nil)
        if swt_widget
          @swt_widget = swt_widget
        else
          if args.first.respond_to?(:swt_widget) && args.first.swt_widget.is_a?(Shell)
            @parent_proxy = args[0]
            args[0] = args[0].swt_widget
          end
          style_args = args.select {|arg| arg.is_a?(Symbol) || arg.is_a?(String)}.map(&:to_sym)
          fill_screen = nil
          if style_args.include?(:fill_screen)
            args.delete(:fill_screen)
            style_args.delete(:fill_screen)
            fill_screen = true
          end
          if style_args.any?
            style_arg_start_index = args.index(style_args.first)
            style_arg_last_index = args.index(style_args.last)
            args[style_arg_start_index..style_arg_last_index] = SWTProxy[style_args]
          end
          if args.first.nil? || (!args.first.is_a?(Display) && !args.first.is_a?(Shell))
            @display = DisplayProxy.instance.swt_display
            args = [@display] + args
          end
          args = args.compact
          @swt_widget = Shell.new(*args)
          @swt_widget.set_data('proxy', self)
          @swt_widget.setLayout(FillLayout.new)
          @swt_widget.setMinimumSize(WIDTH_MIN, HEIGHT_MIN)
          # TODO make this an option not the default
          shell_swt_display = Glimmer::SWT::DisplayProxy.instance.swt_display
          on_swt_show do
            @swt_widget.set_size(@display.bounds.width, @display.bounds.height) if fill_screen
            Thread.new do
              sleep(0.25)
              shell_swt_display.async_exec do
                @swt_widget.setActive unless @swt_widget.isDisposed
              end
            end
          end
        end
        @display ||= @swt_widget.getDisplay
      end

      # Centers shell within monitor it is in
      def center_within_display
        primary_monitor = @display.getPrimaryMonitor()
        monitor_bounds = primary_monitor.getBounds()
        shell_bounds = @swt_widget.getBounds()
        location_x = monitor_bounds.x + (monitor_bounds.width - shell_bounds.width) / 2
        location_y = monitor_bounds.y + (monitor_bounds.height - shell_bounds.height) / 2
        @swt_widget.setLocation(location_x, location_y)
      end

      # Opens shell and starts SWT's UI thread event loop
      def open
        open_only
        start_event_loop unless nested?
      end
      alias show open
      
      # Opens without starting the event loop.
      def open_only
        if @opened_before
          @swt_widget.setVisible(true)
        else
          @opened_before = true
          @swt_widget.pack
          center_within_display
          @swt_widget.open
        end
      end
      
      def nested?
        !swt_widget&.parent.nil?
      end
      
      def disposed?
        swt_widget.isDisposed
      end

      def hide
        @swt_widget.setVisible(false)
      end

      def visible?
        @swt_widget.isDisposed ? false : @swt_widget.isVisible
      end

      # Setting to true opens/shows shell. Setting to false hides the shell.
      def visible=(visibility)
        visibility ? show : hide
      end
      
      def include_focus_control?
        DisplayProxy.instance.focus_control&.shell == swt_widget
      end

      def pack
        @swt_widget.pack
      end

      def pack_same_size
        bounds = @swt_widget.getBounds
        if OS.mac?
          @swt_widget.pack
          @swt_widget.setBounds(bounds)
        elsif OS.windows? || OS::Underlying.windows?
          minimum_size = @swt_widget.getMinimumSize
          @swt_widget.setMinimumSize(bounds.width, bounds.height)
          listener = on_control_resized { @swt_widget.setBounds(bounds) }
          @swt_widget.pack
          @swt_widget.removeControlListener(listener.swt_listener)
          @swt_widget.setMinimumSize(minimum_size)
        elsif OS.linux?
          @swt_widget.layout(true, true)
          @swt_widget.setBounds(bounds)
        end
      end

      def content(&block)
        Glimmer::DSL::Engine.add_content(self, Glimmer::DSL::SWT::ShellExpression.new, &block)
      end

      # (happens as part of `#open`)
      # Starts SWT Event Loop.
      #
      # You may learn more about the SWT Event Loop here:
      # https://help.eclipse.org/2019-12/nftopic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/swt/widgets/Display.html
      # This method is not needed except in rare circumstances where there is a need to start the SWT Event Loop before opening the shell.
      def start_event_loop
        until @swt_widget.isDisposed
          begin
            @display.sleep unless @display.readAndDispatch
          rescue => e
            Glimmer::Config.logger.info {e.full_message}
          end
        end
      end

      def add_observer(observer, property_name)
        case property_name.to_s
        when 'visible?' #TODO see if you must handle non-? version and/or move elsewhere
          visibility_notifier = proc do
            observer.call(visible?)
          end
          on_swt_show(&visibility_notifier)
          on_swt_hide(&visibility_notifier)
          on_swt_close(&visibility_notifier)
        else
          super
        end
      end
      
    end
    
  end
  
end
