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

require 'glimmer/data_binding/observable'
require 'glimmer/data_binding/observer'

module Glimmer
  module DataBinding
    # SWT List widget selection binding
    class ListSelectionBinding
      include Glimmer
      include Observable
      include Observer

      attr_reader :widget_proxy

      PROPERTY_TYPE_UPDATERS = {
        :string => lambda { |widget_proxy, value| widget_proxy.swt_widget.select(widget_proxy.swt_widget.index_of(value.to_s)) },
        :array => lambda { |widget_proxy, value| widget_proxy.swt_widget.selection=(value || []).to_java(:string) }
      }

      PROPERTY_EVALUATORS = {
        :string => lambda do |selection_array|
          return nil if selection_array.empty?
          selection_array[0]
        end,
        :array => lambda do |selection_array|
          selection_array
        end
      }

      # Initialize with list widget and property_type
      # property_type :string represents default list single selection
      # property_type :array represents list multi selection
      def initialize(widget_proxy, property_type)
        property_type = :string if property_type.nil? or property_type == :undefined
        @widget_proxy = widget_proxy
        @property_type = property_type
        @widget_proxy.on_widget_disposed do |dispose_event|
          unregister_all_observables
        end
      end

      def call(value)
        PROPERTY_TYPE_UPDATERS[@property_type].call(@widget_proxy, value) unless evaluate_property == value
      end

      def evaluate_property
        selection_array = @widget_proxy.swt_widget.send('selection').to_a #TODO refactor send('selection') into proper method invocation
        PROPERTY_EVALUATORS[@property_type].call(selection_array)
      end
    end
  end
end
