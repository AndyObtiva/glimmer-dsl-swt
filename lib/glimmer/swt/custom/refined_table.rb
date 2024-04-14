# Copyright (c) 2007-2024 Andy Maleh
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
        option :query, default: ''
        
        attr_accessor :filtered_model_array
        attr_accessor :refined_model_array
        attr_reader :table_proxy, :page_text_proxy, :first_button_proxy, :previous_button_proxy, :next_button_proxy, :last_button_proxy
        
        before_body do
          self.query ||= ''
          @last_query = self.query
          self.model_array ||= []
          self.filtered_model_array = []
          self.refined_model_array = []
        end
        
        after_body do
          Glimmer::DataBinding::Observer.proc do |new_widget_bindings|
            new_widget_bindings.each do |new_widget_binding|
              if new_widget_binding.property.to_s == 'model_array' && !@data_bound
                @data_bound = true
                model_binding = new_widget_binding.model_binding
                configure_sorting
                observe(self, :model_array) do
                  clear_query_cache
                  filter_and_paginate
                end
                @table_proxy.content {
                  items <=> [self, :refined_model_array, model_binding.binding_options]
                }
                filter_and_paginate
              end
            end
          end.observe(body_root.widget_bindings)
        end
        
        body {
          composite {
            text(:search, :border) {
              layout_data(:fill, :center, true, false)
              
              text <=> [self, :query, after_write: -> { filter_and_paginate }]
            }
            
            pagination
            
            @children_owner = @table_proxy = table(*swt_style_symbols) {
              layout_data(:fill, :fill, true, true)
            }
          }
        }
        
        def pagination
          composite {
            layout_data(:fill, :center, true, false)
            
            fill_layout(:horizontal) {
              margin_width 0
              margin_height 0
            }
            
            @first_button_proxy = button {
              text '<<'
              enabled <= [self, :page, on_read: ->(value) {value > first_page}]
              
              on_widget_selected do
                self.page = first_page
                filter_and_paginate
              end
            }
            
            @previous_button_proxy = button {
              text '<'
              enabled <= [self, :page, on_read: ->(value) {value > first_page}]
              
              on_widget_selected do
                self.page -= 1
                filter_and_paginate
              end
            }
            
            @page_text_proxy = text(:border, :center) {
              text <= [self, :page, on_read: ->(value) { "#{value} of #{page_count}" }]
              
              on_focus_gained do
                @page_text_proxy.select_all
              end
              
              on_focus_lost do
                self.page = @page_text_proxy.text.to_i
                filter_and_paginate
              end
              
              on_key_pressed do |key_event|
                if key_event.keyCode == swt(:cr)
                  self.page = @page_text_proxy.text.to_i
                  filter_and_paginate
                end
              end
            }
            
            @next_button_proxy = button {
              text '>'
              enabled <= [self, :page, on_read: ->(value) {value < last_page}]
              
              on_widget_selected do
                self.page += 1
                filter_and_paginate
              end
            }
            
            @last_button_proxy = button {
              text '>>'
              enabled <= [self, :page, on_read: ->(value) {value < last_page}]
              
              on_widget_selected do
                self.page = last_page
                filter_and_paginate
              end
            }
          }
        end
        
        def table_block=(block)
          @table_proxy.content(&block)
        end
        
        def page_text_block=(block)
          @page_text_proxy.content(&block)
        end
        
        def first_button_block=(block)
          @first_button_proxy.content(&block)
        end
        
        def previous_button_block=(block)
          @previous_button_proxy.content(&block)
        end
        
        def next_button_block=(block)
          @next_button_proxy.content(&block)
        end
        
        def last_button_block=(block)
          @last_button_proxy.content(&block)
        end
                
        def page_count
          (filtered_model_array && (filtered_model_array.count / per_page.to_f).ceil) || 0
        end
        
        def corrected_page(initial_page_value = nil)
          correct_page = initial_page_value || page
          correct_page = [correct_page, page_count].min
          correct_page = [correct_page, 1].max
          correct_page = (filtered_model_array&.count.to_i > 0) ? (correct_page > 0 ? correct_page : 1) : 0
          correct_page
        end
        
        def first_page
          (filtered_model_array&.count.to_i > 0) ? 1 : 0
        end
        
        def last_page
          page_count
        end
        
        def filter_and_paginate
          filter
          paginate
        end
        
        def filter
          new_query = query.to_s.strip
          new_filtered_model_array = query_to_filtered_model_array_hash[new_query]
          if new_filtered_model_array.nil?
            if new_query.empty?
              query_to_filtered_model_array_hash[new_query] = new_filtered_model_array = model_array.dup
            else
              new_filtered_model_array = model_array.select do |model|
                @table_proxy.cells_for(model).any? do |cell_text|
                  cell_text.to_s.downcase.include?(new_query.downcase)
                end
              end
              query_to_filtered_model_array_hash[new_query] = new_filtered_model_array
            end
          end
          self.filtered_model_array = new_filtered_model_array
          restore_query_page
          @last_query = new_query
        end
        
        def paginate
          self.page = corrected_page(page)
          self.refined_model_array = filtered_model_array[(page - 1) * per_page, per_page]
        end
        
        def restore_query_page
          new_query = query.to_s.strip
          last_query = @last_query.to_s.strip
          if last_query != new_query
            query_to_page_hash[last_query] = page
          else
            query_to_page_hash[new_query] = page
          end
          if last_query != new_query && last_query.include?(new_query)
            new_page = query_to_page_hash[new_query]
            self.page = corrected_page(new_page) if new_page
          end
        end
        
        def clear_query_cache
          @query_to_filtered_model_array_hash = {}
          @query_to_page_hash = {}
        end
        
        def query_to_filtered_model_array_hash
          @query_to_filtered_model_array_hash ||= {}
        end
        
        def query_to_page_hash
          @query_to_page_hash ||= {}
        end
        
        private
        
        def configure_sorting
          @table_proxy.sort_strategy = lambda do
            new_sort = @table_proxy.sort_block || @table_proxy.sort_by_block || @table_proxy.sort_property
            new_sort_direction = @table_proxy.sort_direction
            return if new_sort == @last_sort && new_sort_direction == @last_sort_direction
            array = model_array.dup
            array = array.sort_by(&:hash) # this ensures consistent subsequent sorting in case there are equivalent sorts to avoid an infinite loop
            # Converting value to_s first to handle nil cases. Should work with numeric, boolean, and date fields
            if @table_proxy.sort_block
              sorted_array = array.sort(&@table_proxy.sort_block)
            elsif @table_proxy.sort_by_block
              sorted_array = array.sort_by(&@table_proxy.sort_by_block)
            else
              sorted_array = array.sort_by do |object|
                @table_proxy.sort_property.each_with_index.map do |a_sort_property, i|
                  value = object.send(a_sort_property)
                  # handle nil and difficult to compare types gracefully
                  if @table_proxy.sort_type[i] == Integer
                    value = value.to_i
                  elsif @table_proxy.sort_type[i] == Float
                    value = value.to_f
                  elsif @table_proxy.sort_type[i] == String
                    value = value.to_s
                  end
                  value
                end
              end
            end
            sorted_array = sorted_array.reverse if @table_proxy.sort_direction == :descending
            self.model_array = sorted_array
            @last_sort = new_sort
            @last_sort_direction = new_sort_direction
          end
        end
      end
    end
  end
end
