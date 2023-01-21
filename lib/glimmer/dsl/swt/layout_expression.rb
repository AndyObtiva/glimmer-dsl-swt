# Copyright (c) 2007-2023 Andy Maleh
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
require 'glimmer/swt/layout_proxy'
require 'glimmer/swt/image_proxy'

module Glimmer
  module DSL
    module SWT
      class LayoutExpression < Expression
        include ParentExpression
  
        include_package 'org.eclipse.swt.widgets'
        include_package 'org.eclipse.swt.graphics'
  
        def can_interpret?(parent, keyword, *args, &block)
          keyword.to_s.end_with?('_layout') and
            parent.respond_to?(:swt_widget) and
            parent.swt_widget.is_a?(Composite) and
            Glimmer::SWT::LayoutProxy.layout_exists?(keyword.to_s)
        end
  
        def interpret(parent, keyword, *args, &block)
          Glimmer::SWT::LayoutProxy.new(keyword, parent, args)
        end
      end
    end
  end
end
