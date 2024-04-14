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

require 'glimmer/dsl/expression'
require 'glimmer/swt/display_proxy'
require 'glimmer/swt/custom/shape'
require 'glimmer/ui/custom_shape'

module Glimmer
  module DSL
    module SWT
      # Widget, Shape, and Display listener experssion
      class ListenerExpression < Expression
        def can_interpret?(parent, keyword, *args, &block)
          Glimmer::Config.logger.debug {"keyword starts with on_: #{keyword.start_with?('on_')}"}
          return false unless keyword.start_with?('on_')
          proper_parent = parent.respond_to?(:swt_widget) || parent.is_a?(Glimmer::SWT::DisplayProxy) || parent.is_a?(Glimmer::SWT::Custom::Shape) || parent.is_a?(Glimmer::UI::CustomShape)
          Glimmer::Config.logger.debug {"parent #{parent} is a widget, shape, or display: #{proper_parent}"}
          return false unless proper_parent
          Glimmer::Config.logger.debug {"block exists?: #{!block.nil?}"}
          raise Glimmer::Error, "Listener is missing block for keyword: #{keyword}" unless block_given?
          Glimmer::Config.logger.debug {"args are empty?: #{args.empty?}"}
          raise Glimmer::Error, "Invalid listener arguments for keyword: #{keyword}(#{args})" unless args.empty?
          result = parent.can_handle_observation_request?(keyword)
          Glimmer::Config.logger.debug {"can add listener? #{result}"}
          raise Glimmer::Error, "Invalid listener keyword: #{keyword}" unless result
          true
        end
  
        def interpret(parent, keyword, *args, &block)
          parent.handle_observation_request(keyword, &block)
        end
      end
    end
  end
end
