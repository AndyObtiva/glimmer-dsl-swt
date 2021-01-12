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
    class WidgetBinding
      include Glimmer
      include Observable
      include Observer

      attr_reader :widget, :property
      def initialize(widget, property, translator = nil)
        @widget = widget
        @property = property
        @translator = translator || proc {|value| value} #TODO check on this it doesn't seem used

        if @widget.respond_to?(:dispose)
          @widget.on_widget_disposed do |dispose_event|
            unregister_all_observables
          end
        end
      end
      
      def call(value)
        converted_value = translated_value = @translator.call(value)
        @widget.set_attribute(@property, converted_value) unless evaluate_property == converted_value
      end
      
      def evaluate_property
        @widget.get_attribute(@property)
      end
    end
  end
end
