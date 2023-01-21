# Copyright (c) 2007-2023 Andy Maleh
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

require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    # Proxy for org.eclipse.swt.widgets.Combo
    #
    # Follows the Proxy Design Pattern
    class ComboProxy < WidgetProxy
      attr_accessor :tool_item_proxy, :swt_tool_item
    
      def initialize(*init_args, &block)
        super
        self.tool_item_proxy = WidgetProxy.new("tool_item", parent_proxy, [:separator]) if parent_proxy.swt_widget.is_a?(ToolBar)
        self.swt_tool_item = tool_item_proxy&.swt_widget
      end
      
      def post_add_content
        if self.tool_item_proxy
          self.swt_widget.pack
          self.tool_item_proxy.text = 'filler' # text seems needed (any text works)
          self.tool_item_proxy.width = swt_widget.size.x
          self.tool_item_proxy.control = swt_widget
        end
      end
    end
  end
end
