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

require 'glimmer/ui/custom_widget'

module Glimmer
  module SWT
    module Custom
      # RefinedTable is a customization of Table with support for Filtering/Pagination
      class RefinedTable
        include Glimmer::UI::CustomWidget
        
        option :per_page, default: 10
        option :model_array
        
        attr_accessor :refined_model_array
        
        before_body do
          self.model_array ||= []
          self.refined_model_array = []
        end
        
        after_body do
          Glimmer::DataBinding::Observer.proc do |new_widget_bindings|
            new_widget_bindings.each do |new_widget_binding|
              if new_widget_binding.property.to_s == 'model_array' && !@data_bound
                @data_bound = true
                model_binding = new_widget_binding.model_binding
                observe(model_binding.base_model, model_binding.property_name_expression) do |all_models|
                  self.refined_model_array = all_models[0, per_page]
                end
                body_root.content {
                  items <=> [self, :refined_model_array, model_binding.binding_options]
                }
                self.refined_model_array = model_binding.evaluate_property[0, per_page]
              end
            end
          end.observe(body_root.widget_bindings)
        end
        
        body {
          table(swt_style) {
          }
        }
      end
    end
  end
end
