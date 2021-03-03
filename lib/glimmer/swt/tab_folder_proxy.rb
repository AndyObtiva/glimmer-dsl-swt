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

require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    # Proxy for org.eclipse.swt.widgets.TabProxy
    #
    # Follows the Proxy Design Pattern
    class TabFolderProxy < WidgetProxy
      def initialize(underscored_widget_name, parent, args, swt_widget: nil)
        @initialize_tabs_on_select = args.delete(:initialize_tabs_on_select)
        super
      end
      
      def post_add_content
        shown = false
        unless @initialize_tabs_on_select
          @show_listener = parent_proxy.on_swt_show do
            unless shown
              shown = true
              self.items.to_a.each do |item|
                self.selection = item
              end
              self.selection = self.items.first unless self.items.first.nil?
              @show_listener.deregister
            end
          end
        end
      end
    end
  end
end
