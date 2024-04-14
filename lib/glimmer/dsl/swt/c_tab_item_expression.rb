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

require 'glimmer'
require 'glimmer/dsl/static_expression'
require 'glimmer/dsl/parent_expression'
require 'glimmer/swt/widget_proxy'
require 'glimmer/swt/c_tab_item_proxy'

module Glimmer
  module DSL
    module SWT
      class CTabItemExpression < StaticExpression
        include ParentExpression
  
        include_package 'org.eclipse.swt.custom'
  
        def can_interpret?(parent, keyword, *args, &block)
          initial_condition = (keyword == 'c_tab_item') and parent.respond_to?(:swt_widget)
          if initial_condition
            if parent.swt_widget.is_a?(CTabFolder)
              return true
            else
              Glimmer::Config.logger.error {"c_tab_item widget may only be used directly under a c_tab_folder widget!"}
            end
          end
          false
        end
  
        def interpret(parent, keyword, *args, &block)
          Glimmer::SWT::CTabItemProxy.new(parent, args)
        end
        
      end
      
    end
    
  end
  
end
