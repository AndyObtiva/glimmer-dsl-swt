require 'glimmer/dsl/static_expression'

module Glimmer
  module DSL
    module SWT
      class CustomPropertyStaticExpression < StaticExpression
        def interpret(parent, keyword, *args, &block)
          parent.send(keyword + '=', args)
        end
      end
    end
  end
end
