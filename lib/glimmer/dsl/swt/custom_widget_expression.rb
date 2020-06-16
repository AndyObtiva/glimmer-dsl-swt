require 'glimmer'
require 'glimmer/dsl/expression'
require 'glimmer/dsl/parent_expression'
require 'glimmer/dsl/top_level_expression'
require 'glimmer/ui/custom_widget'
require 'glimmer/ui/custom_shell'

module Glimmer
  module DSL
    module SWT
      class CustomWidgetExpression < Expression
        # TODO Make custom widgets automatically generate static expressions
        include ParentExpression
        include TopLevelExpression

        def can_interpret?(parent, keyword, *args, &block)
          custom_widget_class = UI::CustomWidget.for(keyword)
          custom_widget_class and
            (parent.respond_to?(:swt_widget) or
            custom_widget_class.ancestors.include?(UI::CustomShell))
        end
  
        def interpret(parent, keyword, *args, &block)
          options = args.last.is_a?(Hash) ? args.pop : {}
          UI::CustomWidget.for(keyword).new(parent, *args, options, &block)
        end
  
        def add_content(parent, &block)
          # TODO consider avoiding source_location
          if block.source_location == parent.content&.__getobj__.source_location
            parent.content.call(parent) unless parent.content.called?
          else
            super
          end
        end
      end
    end
  end
end