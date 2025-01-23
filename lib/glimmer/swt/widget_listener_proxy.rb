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

module Glimmer
  module SWT
    # Proxy for widget listeners
    #
    # Follows the Proxy Design Pattern
    class WidgetListenerProxy

      attr_reader :swt_widget, :swt_display, :swt_listener, :widget_add_listener_method, :swt_listener_class, :swt_listener_method, :event_type, :swt_constant

      def initialize(swt_widget:nil, swt_display:nil, swt_listener:, widget_add_listener_method: nil, swt_listener_class: nil, swt_listener_method: nil, event_type: nil, swt_constant: nil, filter: false)
        @swt_widget = swt_widget
        @swt_display = swt_display
        @filter = filter
        @swt_listener = swt_listener
        @widget_add_listener_method = widget_add_listener_method
        @swt_listener_class = swt_listener_class
        @swt_listener_method = swt_listener_method
        @event_type = event_type
        @swt_constant = swt_constant
      end
      
      def widget_remove_listener_method
        @widget_add_listener_method.sub('add', 'remove')
      end
      
      def deregister
        return if @swt_widget&.is_disposed || @swt_display&.is_disposed
        if @swt_display
          if @filter
            @swt_display.removeFilter(@event_type, @swt_listener)
          else
            @swt_display.removeListener(@event_type, @swt_listener)
          end
        elsif @event_type
          DisplayProxy.instance.auto_exec do
            @swt_widget.removeListener(@event_type, @swt_listener)
          end
        else
          DisplayProxy.instance.auto_exec do
            @swt_widget.send(widget_remove_listener_method, @swt_listener)
          end
        end
      end
      alias unregister deregister # TODO consider dropping unregister (and in Observer too)
    end
  end
end
