require 'glimmer/dsl/expression'
require 'glimmer/swt/image_proxy'

module Glimmer
  module DSL
    module SWT
      # image expression
      # Note: Cannot be a static expression because it clashes with image property expression
      class ImageExpression < Expression
        def can_interpret?(parent, keyword, *args, &block)
          keyword.to_s == 'image' and
            (parent.nil? or !parent.respond_to?('image'))
        end
  
        def interpret(parent, keyword, *args, &block)
          Glimmer::SWT::ImageProxy.new(*args)
        end
      end
    end
  end
end
