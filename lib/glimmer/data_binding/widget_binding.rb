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
