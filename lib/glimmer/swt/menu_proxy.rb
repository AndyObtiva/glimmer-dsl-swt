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
    # Proxy for org.eclipse.swt.widgets.Menu
    #
    # Functions differently from other widget proxies.
    #
    # Glimmer automatically detects if this is a drop down menu
    # or pop up menu from its parent if no SWT style is passed in.
    #
    # There are 3 possibilities:
    # - SWT :bar style is passed in: Menu Bar
    # - Parent is ShellProxy: Pop Up Menu (having style :pop_up)
    # - Parent is another Menu: Drop Down Menu (having style :drop_down)
    #
    # In order to get the SWT Menu object, one must call `#swt_widget`.
    #
    # In the case of a Drop Down menu, this automatically creates an
    # SWT MenuItem object with style :cascade
    #
    # In order to retrieve the menu item widget proxy, one must call `#menu_item_proxy`
    #
    # Follows the Proxy Design Pattern
    class MenuProxy < WidgetProxy
      include_package 'org.eclipse.swt.widgets'

      attr_reader :menu_item_proxy, :swt_menu_item, :menu_parent

      def initialize(parent, args)
        index = args.delete(args.last) if args.last.is_a?(Numeric)
        styles = args.map(&:to_sym)
        if !styles.include?(:bar) && !parent.swt_widget.is_a?(Menu)
          styles = styles.unshift(:pop_up)
        end

        swt_widget_class = self.class.swt_widget_class_for('menu')
        if parent.swt_widget.is_a?(Menu)
          @menu_item_proxy = SWT::WidgetProxy.new('menu_item', parent, [:cascade] + [index].compact)
          @swt_menu_item = @menu_item_proxy.swt_widget
          @swt_widget = swt_widget_class.new(@menu_item_proxy.swt_widget)
          @swt_menu_item.setMenu(swt_widget)
        elsif parent.swt_widget.is_a?(Shell)
          @swt_widget = swt_widget_class.new(parent.swt_widget, style('menu', styles))
        elsif parent.swt_widget.is_a?(TrayItem)
          @swt_widget = swt_widget_class.new(parent.shell_proxy.swt_widget, style('menu', styles))
          parent.menu_proxy = self
        else
          @swt_widget = swt_widget_class.new(parent.swt_widget)
        end

        if styles.include?(:bar)
          DisplayProxy.instance.auto_exec { parent.swt_widget.setMenuBar(swt_widget) }
        elsif styles.include?(:pop_up)
          if parent.swt_widget.is_a?(TrayItem)
            parent.on_menu_detected {
              self.visible = true
            }
          else
            DisplayProxy.instance.auto_exec {
              parent.swt_widget.setMenu(swt_widget) unless parent.swt_widget.is_a?(TrayItem)
            }
          end
        end
      end

      def has_attribute?(attribute_name, *args)
        if ['text', 'enabled'].include?(attribute_name.to_s)
          true
        else
          super(attribute_name, *args)
        end
      end

      def set_attribute(attribute_name, *args)
        if normalized_attribute(attribute_name) == 'text'
          text_value = args[0]
          @swt_menu_item.setText text_value
        elsif normalized_attribute(attribute_name) == 'enabled'
          value = args[0]
          @swt_menu_item.setEnabled value
        else
          super(attribute_name, *args)
        end
      end

      def get_attribute(attribute_name)
        if normalized_attribute(attribute_name) == 'text'
          @swt_menu_item.getText
        elsif normalized_attribute(attribute_name) == 'enabled'
          @swt_menu_item.getEnabled
        else
          super(attribute_name)
        end
      end
      
      def can_handle_observation_request?(observation_request, super_only: false)
        observation_request = observation_request.to_s
        super_result = super(observation_request)
        if observation_request.start_with?('on_') && !super_result && !super_only
          return menu_item_proxy.can_handle_observation_request?(observation_request)
        else
          super_result
        end
      end
      
      def handle_observation_request(observation_request, &block)
        if can_handle_observation_request?(observation_request, super_only: true)
          super
        else
          menu_item_proxy.handle_observation_request(observation_request, &block)
        end
      end
    end
  end
end
