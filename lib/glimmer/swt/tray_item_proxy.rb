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

require 'glimmer/swt/swt_proxy'
require 'glimmer/swt/widget_proxy'
require 'glimmer/swt/tray_proxy'

module Glimmer
  module SWT
    # Proxy for org.eclipse.swt.widgets.TrayItem
    #
    # Invoking `#swt_widget` returns the SWT TrayItem object wrapped by this proxy
    #
    # Follows the Proxy Design Pattern and Flyweight Design Pattern (caching memoization)
    class TrayItemProxy < Glimmer::SWT::WidgetProxy
      attr_reader :tray_proxy, :shell_proxy
      attr_accessor :menu_proxy
      
      def initialize(shell_proxy, *args)
        @shell_proxy = shell_proxy
        @tray_proxy = Glimmer::SWT::TrayProxy.instance
        super('tray_item', @tray_proxy, args)
      end
    end
  end
end
