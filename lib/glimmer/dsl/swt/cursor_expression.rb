require 'glimmer/dsl/expression'
require 'glimmer/swt/cursor_proxy'

module Glimmer
  module DSL
    module SWT
      # cursor expression
      # Note: Cannot be a static expression because it clashes with cursor property expression
      class CursorExpression < Expression
        def can_interpret?(parent, keyword, *args, &block)
          keyword.to_s == 'cursor' and
            (parent.nil? or !parent.respond_to?('cursor')) and
            args.size == 1 and
            (args.first.is_a?(Integer) or textual?(args.first))
        end
  
        def interpret(parent, keyword, *args, &block)
          Glimmer::SWT::CursorProxy.new(*args)
        end
      end
    end
  end
end
