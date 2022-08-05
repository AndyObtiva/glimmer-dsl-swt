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

require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    # Proxy for org.eclipse.swt.widgets.TabItem
    #
    # Functions differently from other widget proxies.
    #
    # Glimmer instantiates an SWT Composite alongside the SWT TabItem
    # and returns it for `#swt_widget` to allow adding widgets into it.
    #
    # In order to get the SWT TabItem object, one must call `#swt_tab_item`.
    #
    # Behind the scenes, this creates a tab item widget proxy separately from a composite that
    # is set as the control of the tab item and `#swt_widget`.
    #
    # In order to retrieve the tab item widget proxy, one must call `#widget_proxy`
    #
    # Follows the Proxy Design Pattern
    class TabItemProxy < WidgetProxy
      ATTRIBUTES = %w[text image tool_tip_text]
      include_package 'org.eclipse.swt.widgets'

      attr_reader :widget_proxy, :swt_tab_item

      def initialize(parent, style, &contents)
        super("composite", parent, style, &contents)
        keyword = self.class.name.split('::').last.underscore.sub('_proxy', '')
        @widget_proxy = SWT::WidgetProxy.new(keyword, parent, style)
        @swt_tab_item = @widget_proxy.swt_widget
        @swt_tab_item.control = swt_widget
      end
      
      def attributes
        ATTRIBUTES
      end

      def has_attribute?(attribute_name, *args)
        attributes.include?(attribute_name.to_s) || super(attribute_name, *args)
      end

      def set_attribute(attribute_name, *args)
        attribute_name = attribute_name.to_s
        if attributes.include?(attribute_name)
          widget_proxy.set_attribute(attribute_name, *args)
        else
          super(attribute_name, *args)
        end
      end

      def get_attribute(attribute_name)
        attribute_name = attribute_name.to_s
        if attributes.include?(attribute_name)
          widget_proxy.get_attribute(attribute_name)
        else
          super(attribute_name)
        end
      end
      
      ATTRIBUTES.each do |attribute|
        define_method(attribute) do
          auto_exec do
            widget_proxy.send(attribute)
          end
        end
        
        define_method("#{attribute}=") do |value|
          value.tap do
            auto_exec do
              widget_proxy.send("#{attribute}=", value)
              shell_proxy.pack_same_size
            end
          end
        end
      end
      
      def dispose
        auto_exec do
          swt_tab_item.setControl(nil)
          swt_widget.dispose
          swt_tab_item.dispose
        end
      end
      
    end
        
  end
  
end
