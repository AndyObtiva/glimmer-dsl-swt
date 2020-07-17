require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    class TableColumnProxy < Glimmer::SWT::WidgetProxy    
      attr_reader :no_sort, :sort_property, :editor
      alias no_sort? no_sort
      attr_accessor :sort_block, :sort_by_block
      
      def initialize(underscored_widget_name, parent, args)
        @no_sort = args.delete(:no_sort)
        super
        parent.add_table_column_proxy(self)
        on_widget_selected do |event|
          parent.sort_by_column(self)
        end unless no_sort?
      end
      
      def sort_property=(args)
        @sort_property = args unless args.empty?
      end
      
      def editor=(args)
        @editor = args
      end
      
    end
  end
end
