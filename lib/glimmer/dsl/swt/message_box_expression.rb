require 'glimmer/dsl/static_expression'
require 'glimmer/dsl/parent_expression'
require 'glimmer/dsl/top_level_expression'
require 'glimmer/swt/shell_proxy'
require 'glimmer/swt/message_box_proxy'
require 'glimmer/swt/swt_proxy'

module Glimmer
  module DSL
    module SWT
      class MessageBoxExpression < StaticExpression
        include TopLevelExpression
        include ParentExpression

        include_package 'org.eclipse.swt.widgets'

        def interpret(parent, keyword, *args, &block)
          potential_parent = args.first
          potential_parent = potential_parent.swt_widget if potential_parent.respond_to?(:swt_widget)
          parent = nil          
          if potential_parent.is_a?(Shell)
            args.shift
            parent = potential_parent
          elsif potential_parent.is_a?(Widget)
            args.shift
            parent = potential_parent.shell
          end
          Glimmer::SWT::MessageBoxProxy.new(parent, Glimmer::SWT::SWTProxy[args])
        end
      end
    end
  end
end
