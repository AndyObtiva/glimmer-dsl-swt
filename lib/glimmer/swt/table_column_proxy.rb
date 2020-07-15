require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    class TableColumnProxy < Glimmer::SWT::WidgetProxy
      attr_reader :no_sort
      alias no_sort? no_sort
      def initialize(underscored_widget_name, parent, args)
        @no_sort = args.delete(:no_sort)
        super
        on_widget_selected do |event|
          parent.sort_by_column(self)
        end unless no_sort?
      end
    end
  end
end
