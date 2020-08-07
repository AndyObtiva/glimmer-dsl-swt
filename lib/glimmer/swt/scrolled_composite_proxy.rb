require 'glimmer/swt/widget_proxy'
require 'glimmer/swt/swt_proxy'

module Glimmer
  module SWT
    class ScrolledCompositeProxy < Glimmer::SWT::WidgetProxy    
      def post_initialize_child(child)
        swt_widget.content = child.swt_widget        
      end
      
      def post_add_content
        swt_widget.set_min_size(swt_widget.computeSize(SWTProxy[:default], SWTProxy[:default]))
      end      
    end
  end
end
