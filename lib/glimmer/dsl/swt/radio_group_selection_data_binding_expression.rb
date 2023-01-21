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
require 'glimmer/data_binding/model_binding'
require 'glimmer/data_binding/widget_binding'
require 'glimmer/swt/display_proxy'

module Glimmer
  module DSL
    module SWT
      class RadioGroupSelectionDataBindingExpression < Expression
 
        def can_interpret?(parent, keyword, *args, &block)
          keyword == 'selection' and
            block.nil? and
            (parent.is_a?(Glimmer::SWT::Custom::RadioGroup) or (parent.is_a?(Glimmer::UI::CustomWidget) and parent.body_root.is_a?(Glimmer::SWT::Custom::RadioGroup)) ) and
            args.size == 1 and
            args[0].is_a?(DataBinding::ModelBinding) and
            args[0].evaluate_options_property.is_a?(Array)
        end
  
        def interpret(parent, keyword, *args, &block)
          model_binding = args[0]
  
          #TODO make this options observer dependent and all similar observers in widget specific data binding handlers
          # TODO consider delegating some of this work
          widget_binding = DataBinding::WidgetBinding.new(parent, 'items', sync_exec: model_binding.binding_options[:sync_exec], async_exec: model_binding.binding_options[:async_exec])
          widget_binding.call(model_binding.evaluate_options_property)
          model = model_binding.base_model
          widget_binding.observe(model, model_binding.options_property_name)
  
          widget_binding = DataBinding::WidgetBinding.new(parent, 'selection', sync_exec: model_binding.binding_options[:sync_exec], async_exec: model_binding.binding_options[:async_exec])
          widget_binding.call(model_binding.evaluate_property)
          widget_binding.observe(model_binding)
  
          raise(Glimmer::Error, "No radios found! Make sure radio selection is data-bound to a property having property_options as non-empty array!") if parent.get_items.empty?
          Glimmer::SWT::DisplayProxy.instance.auto_exec(override_sync_exec: model_binding.binding_options[:sync_exec], override_async_exec: model_binding.binding_options[:async_exec]) do
            parent.on_widget_selected do
              model_binding.call(widget_binding.evaluate_property)
            end
          end
        end
      end
    end
  end
end
