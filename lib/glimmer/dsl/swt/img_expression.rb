require 'glimmer/dsl/static_expression'
require 'glimmer/dsl/top_level_expression'
require 'glimmer/swt/image_proxy'

module Glimmer
  module DSL
    module SWT
      # image expression
      # Note: Cannot be a static expression because it clashes with image property expression
      class ImgExpression < StaticExpression
        include TopLevelExpression
  
        def interpret(parent, keyword, *args, &block)
          Glimmer::SWT::ImageProxy.new(*args)
        end
      end
    end
  end
end
