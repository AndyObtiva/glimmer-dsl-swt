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

require 'glimmer/swt/widget_proxy'
require 'glimmer/swt/swt_proxy'

module Glimmer
  module SWT
    class ScrolledCompositeProxy < Glimmer::SWT::WidgetProxy
      def post_initialize_child(child)
        auto_exec do
          swt_widget.content = child.swt_widget
        end
        # TODO consider triggering this method in the future upon resizing of content with a listener (on_control_resized)
#         child.on_control_resized do
#           swt_widget.set_min_size(swt_widget.computeSize(child.bounds.width, child.bounds.height))
#         end
      end
      
      def post_add_content
        calculate_min_size
      end
      
      def calculate_min_size
        auto_exec do
          swt_widget.set_min_size(swt_widget.computeSize(SWTProxy[:default], SWTProxy[:default]))
        end
      end
      alias recalculate_min_size calculate_min_size
    end
  end
end
