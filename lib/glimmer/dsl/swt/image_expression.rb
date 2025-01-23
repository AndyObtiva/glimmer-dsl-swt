# Copyright (c) 2007-2025 Andy Maleh
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'glimmer/dsl/expression'
require 'glimmer/dsl/top_level_expression'
require 'glimmer/dsl/parent_expression'
require 'glimmer/swt/image_proxy'
require 'glimmer/swt/widget_proxy'

module Glimmer
  module DSL
    module SWT
      # image expression
      # Note: Cannot be a static expression because it clashes with image property expression
      class ImageExpression < Expression
        include TopLevelExpression
        include ParentExpression
        
        def can_interpret?(parent, keyword, *args, &block)
          options = args.last.is_a?(Hash) ? args.last : {}
          (keyword == 'image') and
            (!args.empty?) and
            (
              options.keys.include?(:top_level) or
              (
                !parent.is_a?(Glimmer::SWT::Custom::Shape) and
                (parent.nil? or parent.respond_to?('image=') or args.first.is_a?(Numeric))
              )
            )
        end
  
        def interpret(parent, keyword, *args, &block)
          options = args.last.is_a?(Hash) ? args.last : {}
          coordinate_args = args.size == (options.empty? ? 2 : 3)
          args.unshift(parent) unless parent.nil? || options[:top_level]
          @create_pixel_by_pixel = coordinate_args && block&.parameters&.count == 2
          if @create_pixel_by_pixel
            Glimmer::SWT::ImageProxy.create_pixel_by_pixel(*args, &block)
          else
            Glimmer::SWT::ImageProxy.create(*args, &block)
          end
        end

        def add_content(parent, keyword, *args, &block)
          return if @create_pixel_by_pixel || block&.parameters&.count == 2
          super
          parent.post_add_content
        end
      end
    end
  end
end
