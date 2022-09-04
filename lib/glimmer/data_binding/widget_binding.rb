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

require 'glimmer/data_binding/observable'
require 'glimmer/data_binding/observer'

require 'glimmer/swt/display_proxy'

module Glimmer
  module DataBinding
    class WidgetBinding
      include Glimmer
      include Observable
      include Observer

      attr_reader :widget, :property, :model_binding
      
      def initialize(widget, property, sync_exec: nil, async_exec: nil)
        @widget = widget
        @property = property
        @sync_exec = sync_exec
        @async_exec = async_exec
        SWT::DisplayProxy.instance.auto_exec(override_sync_exec: @sync_exec, override_async_exec: @async_exec) do
          if @widget.is_a?(Glimmer::SWT::WidgetProxy) && @widget.respond_to?(:on_widget_disposed)
            @widget.on_widget_disposed do |dispose_event|
              unless @widget.shell_proxy.last_shell_closing?
                @widget_proxy.widget_bindings.delete(self)
                deregister_all_observables
              end
            end
          end
          # TODO look into hooking on_shape_disposed without slowing down shapes in samples like Tetris
        end
        @widget_proxy = widget.is_a?(Glimmer::SWT::WidgetProxy) ? widget : widget.body_root
      end
      
      def observe(*args)
        # assumes only one observation
        @model_binding = args.first if args.size == 1
        @widget_proxy.widget_bindings << self
        super
      end
      
      def call(value)
        SWT::DisplayProxy.instance.auto_exec(override_sync_exec: @sync_exec, override_async_exec: @async_exec) do
          if @widget.respond_to?(:disposed?) && @widget.disposed?
            unless @widget.shell_proxy.last_shell_closing?
              @widget_proxy.widget_bindings.delete(self)
              deregister_all_observables
            end
            return
          end
          # need the rescue false for a scenario with tree items not being equal to model objects raising an exception
          if @async_exec || !((value == evaluate_property) rescue false) # need the rescue false for a scenario with tree items not being equal to model objects raising an exception
            @widget.set_attribute(@property, value)
          end
        end
      end
      
      def evaluate_property
        if @widget.respond_to?(:disposed?) && @widget.disposed?
          unless @widget.shell_proxy.last_shell_closing?
            @widget_proxy.widget_bindings.delete(self)
            deregister_all_observables
          end
          return
        end
        @widget.get_attribute(@property)
      end
    end
  end
end
