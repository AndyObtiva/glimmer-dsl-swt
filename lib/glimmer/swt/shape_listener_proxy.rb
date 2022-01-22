# Copyright (c) 2007-2022 Andy Maleh
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
    class ShapeListenerProxy

      attr_reader :shape, :observation_request, :widget_listener_proxy

      def initialize(shape: nil, drawable: nil, shape_listener_block: nil, observation_request: nil, widget_listener_proxy: nil)
        @shape = shape
        @drawable = drawable
        @shape_listener_block = shape_listener_block
        @observation_request = observation_request
        @widget_listener_proxy = widget_listener_proxy
      end
      
      # Deregisters shape listener
      def deregister
        if @observation_request == 'on_drop'
          @widget_listener_proxy.deregister
          @shape.widget_listener_proxies.delete(@widget_listener_proxy)
          @drawable.drop_shapes.delete(shape)
        elsif @observation_request == 'on_shape_disposed'
          @shape.remove_shape_disposed_listener(@shape_listener_block)
        else
          @widget_listener_proxy.deregister
          @shape.widget_listener_proxies.delete(@widget_listener_proxy)
        end
      end
      alias unregister deregister # TODO consider dropping unregister (and in Observer too)
    end
  end
end
