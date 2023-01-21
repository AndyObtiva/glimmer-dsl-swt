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

require 'glimmer/dsl/expression'

require 'glimmer/swt/transform_proxy'

module Glimmer
  module DSL
    module SWT
      class PropertyExpression < Expression
        def can_interpret?(parent, keyword, *args, &block)
          block.nil? and
            (args.size > 0 || parent.is_a?(Glimmer::SWT::TransformProxy)) and
            parent.respond_to?(:set_attribute) and
            parent.respond_to?(:has_attribute?) and
            parent.has_attribute?(keyword, *args) and
            !(parent.respond_to?(:swt_widget) && parent.swt_widget.class == org.eclipse.swt.widgets.Canvas && keyword == 'image')
        end
  
        def interpret(parent, keyword, *args, &block)
          parent.set_attribute(keyword, *args)
          parent
        end
      end
    end
  end
end
