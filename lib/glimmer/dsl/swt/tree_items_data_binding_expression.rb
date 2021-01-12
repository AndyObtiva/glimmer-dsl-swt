# Copyright (c) 2007-2021 Andy Maleh
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
require 'glimmer/data_binding/model_binding'
require 'glimmer/data_binding/tree_items_binding'

module Glimmer
  module DSL
    module SWT
      class TreeItemsDataBindingExpression < Expression
        include_package 'org.eclipse.swt.widgets'
  
        def can_interpret?(parent, keyword, *args, &block)
          initial_condition = ((keyword == "items") and block.nil? and parent.respond_to?(:swt_widget) and parent.swt_widget.is_a?(Tree))
          return false unless initial_condition
          raise Glimmer::Error, 'Tree items args must be 2' unless args.size == 2
          raise Glimmer::Error, 'Tree items first arg must be a bind expression' unless args[0].is_a?(DataBinding::ModelBinding)
          raise Glimmer::Error, 'Tree items data-binding initial value must not be an array yet a single item representing tree root' unless !args[0].evaluate_property.is_a?(Array)
          raise Glimmer::Error, 'Tree items second arg must be an array' unless args[1].is_a?(Array)
          raise Glimmer::Error, 'Tree items second arg must not be empty' unless !args[1].empty?
          raise Glimmer::Error, 'Tree items second arg array elements must be of type hash' unless args[1].first.is_a?(Hash)
          true
        end
  
        def interpret(parent, keyword, *args, &block)
          model_binding = args[0]
          tree_properties = args[1]
          DataBinding::TreeItemsBinding.new(parent, model_binding, tree_properties)
        end
      end
    end
  end
end
