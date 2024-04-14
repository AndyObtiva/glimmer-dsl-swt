# Copyright (c) 2007-2024 Andy Maleh
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
    # Proxy for org.eclipse.swt.widgets.ExpandItem
    #
    # Functions differently from other widget proxies.
    #
    # Glimmer instantiates an SWT Composite alongside the SWT ExpandItem
    # and returns it for `#swt_widget` to allow adding widgets into it.
    #
    # In order to get the SWT ExpandItem object, one must call `#swt_expand_item`.
    #
    # Behind the scenes, this creates a tab item widget proxy separately from a composite that
    # is set as the control of the tab item and `#swt_widget`.
    #
    # In order to retrieve the tab item widget proxy, one must call `#widget_proxy`
    #
    # Follows the Proxy Design Pattern
    class ExpandItemProxy < WidgetProxy
      ATTRIBUTES = ['text', 'height', 'expanded']
      
      include_package 'org.eclipse.swt.widgets'

      attr_reader :widget_proxy, :swt_expand_item

      def initialize(parent, style, &contents)
        super("composite", parent, style, &contents)
        layout = FillLayout.new(SWTProxy[:vertical])
        layout.marginWidth = 0
        layout.marginHeight = 0
        layout.spacing = 0
        swt_widget.layout = layout
        auto_exec do
          @widget_proxy = SWT::WidgetProxy.new('expand_item', parent, style)
          @swt_expand_item = @widget_proxy.swt_widget
          @swt_expand_item.control = swt_widget
          @swt_expand_item.expanded = true
        end
      end
      
      def post_add_content
        auto_exec do
          @swt_expand_item.setHeight(swt_widget.computeSize(SWTProxy[:default], SWTProxy[:default]).y) unless @swt_expand_item.getHeight > 0
        end
      end
      
      def has_attribute?(attribute_name, *args)
        if ATTRIBUTES.include?(attribute_name.to_s)
          true
        else
          super(attribute_name, *args)
        end
      end

      def set_attribute(attribute_name, *args)
        if ATTRIBUTES.include?(attribute_name.to_s)
          @widget_proxy.set_attribute(attribute_name, *args)
        else
          super(attribute_name, *args)
        end
      end

      def get_attribute(attribute_name)
        if ATTRIBUTES.include?(attribute_name.to_s)
          @widget_proxy.get_attribute(attribute_name)
        else
          super(attribute_name)
        end
      end
      
      def dispose
        auto_exec do
          swt_expand_item.setControl(nil)
          swt_widget.dispose
          swt_expand_item.dispose
        end
      end
    end
  end
end
