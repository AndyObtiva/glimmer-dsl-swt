require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    class ScrolledCompositeProxy < Glimmer::SWT::WidgetProxy
      def initialize(underscored_widget_name, parent, args)
        unless args.first.is_a?(Numeric)
          args.unshift(:h_scroll)
          args.unshift(:v_scroll)
        end
        super
        swt_widget.expand_horizontal = true
        swt_widget.expand_vertical = true
      end
      
      def post_initialize_child(child)
        swt_widget.content = child.swt_widget        
      end
    end
  end
end
