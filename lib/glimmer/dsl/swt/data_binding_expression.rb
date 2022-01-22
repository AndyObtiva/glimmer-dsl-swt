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

require 'glimmer/dsl/expression'
require 'glimmer/data_binding/model_binding'
require 'glimmer/data_binding/widget_binding'
require 'glimmer/swt/display_proxy'

module Glimmer
  module DSL
    module SWT
      # Responsible for wiring two-way data-binding for text and selection properties
      # on Text, Button, and Spinner widgets.
      # Does so by using the output of the bind(model, property) command in the form
      # of a ModelBinding, which is then connected to an anonymous widget observer
      # (aka widget_data_binder as per widget_data_binders array)
      #
      # Depends on BindExpression
      class DataBindingExpression < Expression
        def can_interpret?(parent, keyword, *args, &block)
          args.size == 1 and
            args[0].is_a?(DataBinding::ModelBinding)
        end
  
        def interpret(parent, keyword, *args, &block)
          model_binding = args[0]
          widget_binding = DataBinding::WidgetBinding.new(parent, keyword, sync_exec: model_binding.binding_options[:sync_exec], async_exec: model_binding.binding_options[:async_exec])
          widget_binding.call(model_binding.evaluate_property)
          #TODO make this options observer dependent and all similar observers in widget specific data binding handlers
          widget_binding.observe(model_binding)
          # TODO simplify this logic and put it where it belongs
          parent.add_observer(model_binding, keyword) if parent.respond_to?(:add_observer, [model_binding, keyword])
        end
      end
    end
  end
end
