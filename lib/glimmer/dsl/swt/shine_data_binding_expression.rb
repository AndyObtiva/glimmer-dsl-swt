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

require 'glimmer/dsl/shine_data_binding_expression'
require 'glimmer/data_binding/model_binding'
require 'glimmer/data_binding/widget_binding'
require 'glimmer/swt/display_proxy'
require 'glimmer/data_binding/shine'

module Glimmer
  module DSL
    module SWT
      class ShineDataBindingExpression < Glimmer::DSL::ShineDataBindingExpression
        include_package 'org.eclipse.swt.widgets'
        
        def can_interpret?(parent, keyword, *args, &block)
          super and
            (
              (parent.respond_to?(:has_attribute?) and parent.has_attribute?(keyword)) or
              (parent.respond_to?(:swt_widget) and (parent.swt_widget.is_a?(Table) or parent.swt_widget.is_a?(Tree)))
            ) and
            !(parent.respond_to?(:swt_widget) && parent.swt_widget.class == org.eclipse.swt.widgets.Canvas && keyword == 'image')
        end
      end
    end
  end
end
