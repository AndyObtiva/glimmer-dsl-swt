require 'glimmer/dsl/expression'

module Glimmer
  module DSL
    module SWT
      class BlockPropertyExpression < Expression
        def can_interpret?(parent, keyword, *args, &block)
          block_given? and
            args.size == 0 and
            parent.respond_to?("#{keyword}_block=")
        end
  
        def interpret(parent, keyword, *args, &block)
          parent.send("#{keyword}_block=", block)
          nil
        end
      end
    end
  end
end
