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

require 'glimmer'
require 'glimmer/dsl/expression'
require 'glimmer/dsl/parent_expression'
require 'glimmer/dsl/top_level_expression'
require 'glimmer/ui/custom_shape'
require 'glimmer/swt/custom/code_text'
require 'glimmer/swt/custom/checkbox_group'

module Glimmer
  module DSL
    module SWT
      class CustomShapeExpression < Expression
        # TODO Make custom shapes automatically generate static expressions
        include ParentExpression
        include TopLevelExpression

        def can_interpret?(parent, keyword, *args, &block)
          !!UI::CustomShape.for(keyword)
        end
  
        def interpret(parent, keyword, *args, &block)
          options = args.last.is_a?(Hash) ? args.pop : {}
            UI::CustomShape.for(keyword).new(parent, *args, options, &block).tap do |new_custom_shape|
            new_custom_shape.body_root.paint_pixel_by_pixel(&block) if block&.parameters&.count == 2
          end
        end
  
        def add_content(parent, keyword, *args, &block)
          # TODO consider avoiding source_location
          return if block&.parameters&.count == 2
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
