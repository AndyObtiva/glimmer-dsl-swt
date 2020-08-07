require 'glimmer/dsl/expression'
require 'glimmer/dsl/top_level_expression'
require 'glimmer/swt/font_proxy'

module Glimmer
  module DSL
    module SWT
      # font expression
      # Note: Cannot be a static expression because it clashes with font property expression
      class FontExpression < Expression
        include TopLevelExpression
  
        def can_interpret?(parent, keyword, *args, &block)
          keyword.to_s == 'font' and     
            (parent.nil? || !parent.respond_to?('font')) and
            args.size == 1 and 
            args.first.is_a?(Hash)
        end
  
        def interpret(parent, keyword, *args, &block)
          Glimmer::SWT::FontProxy.new(*args)
        end
      end
    end
  end
end
