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
        option :page, default: 0
        option :model_array
        
        attr_accessor :refined_model_array
        attr_reader :table_proxy, :page_text_proxy
        
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
                observe(self, :model_array) do
                  paginate
                end
                @table_proxy.content {
                  items(dsl: true) <=> [self, :refined_model_array, model_binding.binding_options]
                }
                paginate
              end
            end
          end.observe(body_root.widget_bindings)
        end
        
        body {
          composite {
            composite {
              layout_data(:fill, :center, true, false)
              
              fill_layout(:horizontal)
              
              button {
                text '<<'
                
                on_widget_selected do
                  self.page = first_page
                  paginate
                end
              }
              
              button {
                text '<'
                
                on_widget_selected do
                  self.page -= 1
                  paginate
                end
              }
              
              @page_text_proxy = text(:border, :center) {
                text <= [self, :page, on_read: ->(value) { "#{value} of #{page_count}" }]
                
                on_focus_gained do
                  @page_text_proxy.select_all
                end
                
                on_key_pressed do |key_event|
                  if key_event.keyCode == swt(:cr)
                    self.page = @page_text_proxy.text.to_i
                    paginate
                  end
                end
              }
              
              button {
                text '>'
                
                on_widget_selected do
                  self.page += 1
                  paginate
                end
              }
              
              button {
                text '>>'
                
                on_widget_selected do
                  self.page = last_page
                  paginate
                end
              }
            }
            
            @children_owner = @table_proxy = table(swt_style)
          }
        }
        
        def table_block=(block)
          @table_proxy.content(&block)
        end
        
        def method_missing(method_name, *args, &block)
          dsl_mode = @dsl_mode || args.last.is_a?(Hash) && args.last[:dsl]
          if dsl_mode
            args.pop if args.last.is_a?(Hash) && args.last[:dsl]
            super(method_name, *args, &block)
          elsif @table_proxy&.respond_to?(method_name, *args, &block)
            @table_proxy&.send(method_name, *args, &block)
          else
            super
          end
        end
        
        def respond_to?(method_name, *args, &block)
          dsl_mode = @dsl_mode || args.last.is_a?(Hash) && args.last[:dsl]
          if dsl_mode
            args = args[0...-1] if args.last.is_a?(Hash) && args.last[:dsl]
            super(method_name, *args, &block)
          else
            super || @table_proxy&.respond_to?(method_name, *args, &block)
          end
        end
        
        def page_count
          (model_array && (model_array.count / per_page.to_f).ceil) || 0
        end
        
        def corrected_page(initial_page_value = nil)
          correct_page = initial_page_value || page
          correct_page = [correct_page, page_count].min
          correct_page = [correct_page, 1].max
          correct_page = (model_array&.count.to_i > 0) ? (correct_page > 0 ? correct_page : 1) : 0
          correct_page
        end
        
        def first_page
          (model_array&.count.to_i > 0) ? 1 : 0
        end
        
        def last_page
          page_count
        end
        
        def paginate
          self.page = corrected_page(page)
          self.refined_model_array = model_array[(page - 1) * per_page, per_page]
        end
      end
    end
  end
end
