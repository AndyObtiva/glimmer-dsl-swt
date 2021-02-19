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

require 'glimmer/swt/display_proxy'

module Glimmer
  module DataBinding
    class WidgetBinding
      include Glimmer
      include Observable
      include Observer

      attr_reader :widget, :property
      def initialize(widget, property, sync_exec: false)
        @widget = widget
        @property = property
        @sync_exec = sync_exec

        if @widget.respond_to?(:on_widget_disposed)
          @widget.on_widget_disposed do |dispose_event|
            unregister_all_observables
          end
        end
      end
      
      def call(value)
        update_operation = lambda do
          if @widget.respond_to?(:disposed?) && @widget.disposed?
            unregister_all_observables
            return
          end
          @widget.set_attribute(@property, value) unless evaluate_property == value
        end
        if @sync_exec || Config.auto_sync_exec? && Config.require_sync_exec?
          SWT::DisplayProxy.instance.sync_exec(&update_operation)
        else
          update_operation.call
        end
      end
      
      def evaluate_property
        if @widget.respond_to?(:disposed?) && @widget.disposed?
          unregister_all_observables
          return
        end
        return_value = nil
        read_operation = lambda do
          return_value = @widget.get_attribute(@property)
        end
        if @sync_exec || Config.auto_sync_exec? && Config.require_sync_exec?
          SWT::DisplayProxy.instance.sync_exec(&read_operation)
        else
          read_operation.call
        end
        return_value
      end
    end
  end
end
