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

require 'glimmer/swt/display_proxy'

module Glimmer
  module SWT
    # Proxy for org.eclipse.swt.widgets.Tray
    #
    # Invoking `#swt_widget` returns the SWT Tray object wrapped by this proxy
    #
    # Follows the Proxy Design Pattern and Flyweight Design Pattern (caching memoization)
    class TrayProxy
      class << self
        def instance
          @instance ||= new(Glimmer::SWT::DisplayProxy.instance)
        end
      end
      
      attr_reader :swt_widget
      
      def initialize(display_proxy)
        @swt_widget = display_proxy.getSystemTray
      end
      
      def method_missing(method_name, *args, &block)
        @swt_widget.send(method_name, *args, &block)
      end
      
      def respond_to?(method_name, *args, &block)
        super || @swt_widget.respond_to?(method_name, *args, &block)
      end
      
      def post_initialize_child(child)
        # No Op
      end

      # Subclasses may override to perform post add_content work.
      # Make sure its logic detects if it ran before since it could run multiple times
      # when adding content multiple times post creation.
      def post_add_content
        # No Op
      end
    end
  end
end
