# Copyright (c) 2007-2022 Andy Maleh
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

require 'glimmer/dsl/static_expression'
require 'glimmer/dsl/top_level_expression'
require 'glimmer/dsl/parent_expression'
require 'glimmer/swt/shell_proxy'
require 'glimmer/swt/message_box_proxy'
require 'glimmer/swt/swt_proxy'

module Glimmer
  module DSL
    module SWT
      class MessageBoxExpression < StaticExpression
        include TopLevelExpression
        include ParentExpression

        include_package 'org.eclipse.swt.widgets'

        def interpret(parent, keyword, *args, &block)
          potential_parent = args.first
          potential_parent = potential_parent.swt_widget if potential_parent.respond_to?(:swt_widget)
          parent = nil
          if potential_parent.is_a?(Shell)
            args.shift
            parent = potential_parent
          elsif potential_parent.is_a?(Widget)
            args.shift
            parent = potential_parent.shell
          end
          Glimmer::SWT::MessageBoxProxy.new(parent, Glimmer::SWT::SWTProxy[args])
        end
      end
    end
  end
end
