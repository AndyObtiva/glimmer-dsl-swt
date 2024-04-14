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

require 'glimmer/error'
require 'glimmer/swt/swt_proxy'
require 'glimmer/swt/display_proxy'

module Glimmer
  module SWT
    # Proxy for org.eclipse.swt.graphics.Font
    #
    # This class can be optionally used with WidgetProxy to manipulate
    # an SWT widget font (reusing its FontData but building a new Font)
    #
    # Otherwise, if no WidgetProxy is passed to constructor, it builds new FontData
    #
    # Invoking `#swt_font` returns the SWT Font object wrapped by this proxy
    #
    # Follows the Proxy Design Pattern
    class FontProxy
      class << self
        def create(*args)
          flyweight_font_proxies[args] ||= new(*args)
        end
        
        # Flyweight Design Pattern memoization cache. Can be cleared if memory is needed.
        def flyweight_font_proxies
          @flyweight_font_proxies ||= {}
        end
      end

      include_package 'org.eclipse.swt.graphics'
      
      ERROR_INVALID_FONT_STYLE = " is an invalid font style! Valid values are :normal, :bold, and :italic"
      FONT_STYLES = [:normal, :bold, :italic]

      attr_reader :widget_proxy, :swt_font, :font_properties

      # Builds a new font proxy from passed in widget_proxy and font_properties hash,
      #
      # It begins with existing SWT widget font and amends it with font properties.
      #
      # Font properties consist of: :name, :height, and :style (one needed minimum)
      #
      # Style (:style value) can only be one of FontProxy::FONT_STYLES values:
      # that is :normal, :bold, or :italic
      def initialize(widget_proxy = nil, font_properties)
        @widget_proxy = widget_proxy
        if font_properties.is_a?(FontData)
          font_datum = font_properties
          @font_properties = {name: font_properties.name, height: font_properties.height, style: font_properties.style}
        elsif font_properties.is_a?(Hash)
          @font_properties = font_properties
          detect_invalid_font_property(font_properties)
          font_properties[:style] = SWTProxy[*font_properties[:style]]
          # TODO consider supporting other properties like locale in the future
          font_data_args = [:name, :height, :style].map do |font_property_name|
            font_properties[font_property_name] || send(font_property_name)
          end
          font_datum = FontData.new(*font_data_args)
        end
        @swt_font = Font.new(DisplayProxy.instance.swt_display, font_datum)
      end

      def name
        font_datum.getName
      end

      def height
        font_datum.getHeight
      end

      def style
        font_datum.getStyle
      end

      private

      def font_datum
        @font_datum ||= DisplayProxy.instance.auto_exec { @widget_proxy ? @widget_proxy.swt_widget.getFont.getFontData[0] : FontData.new }
      end

      def detect_invalid_font_property(font_properties)
        [font_properties[:style]].flatten.select do |style|
          style.is_a?(Symbol) || style.is_a?(String)
        end.each do |style|
          raise Error, style.to_s + ERROR_INVALID_FONT_STYLE if !FONT_STYLES.include?(style.to_sym)
        end
      end
    end
  end
end
