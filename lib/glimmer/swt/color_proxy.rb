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

require 'glimmer/swt/swt_proxy'
require 'glimmer/swt/display_proxy'

module Glimmer
  module SWT
    # Proxy for org.eclipse.swt.graphics.Color
    #
    # Invoking `#swt_color` returns the SWT Color object wrapped by this proxy
    #
    # Follows the Proxy Design Pattern and Flyweight Design Pattern (caching memoization)
    class ColorProxy
      include_package 'org.eclipse.swt.graphics'
      
      class << self
        def create(*args)
          flyweight_color_proxies[args] ||= new(*args)
        end
        
        # Flyweight Design Pattern memoization cache. Can be cleared if memory is needed.
        def flyweight_color_proxies
          @flyweight_color_proxies ||= {}
        end
      end

      # Initializes a proxy for an SWT Color object
      #
      # Takes a standard color single argument, rgba 3 args, or rgba 4 args
      #
      # A standard color is a string/symbol representing one of the
      # SWT.COLOR_*** constants like SWT.COLOR_RED, but in underscored string
      # format (e.g :color_red).
      # Glimmer can also accept standard color names without the color_ prefix,
      # and it will automatically figure out the SWT.COLOR_*** constant
      # (e.g. :red)
      #
      # rgb is 3 arguments representing Red, Green, Blue numeric values
      #
      # rgba is 4 arguments representing Red, Green, Blue, and Alpha numeric values
      #
      def initialize(*args)
        @options = args.last.is_a?(Hash) ? args.pop : {}
        @args = args
        @args = @args.first if @args.first.is_a?(Array)
        ensure_arg_values_within_valid_bounds unless @options[:ensure_bounds] == false
      end

      def swt_color
        unless @swt_color
          case @args.size
          when 1
            if @args.first.is_a?(String) || @args.first.is_a?(Symbol)
              standard_color = @args.first
              standard_color = "color_#{standard_color}".to_sym unless standard_color.to_s.downcase.include?('color_')
              @swt_color = DisplayProxy.instance.swt_display.getSystemColor(SWTProxy[standard_color])
            else
              @swt_color = @args.first
            end
          when 3..4
            @swt_color = Color.new(*@args)
          end
        end
        @swt_color
      end
      
      def method_missing(method_name, *args, &block)
        swt_color.send(method_name, *args, &block)
      rescue => e
        Glimmer::Config.logger.debug {"Neither ColorProxy nor #{swt_color.class.name} can handle the method ##{method_name}"}
        super
      end
      
      def respond_to?(method_name, *args, &block)
        super || swt_color.respond_to?(method_name, *args, &block)
      end
      
      private
      
      def ensure_arg_values_within_valid_bounds
        if @args.to_a.size >= 3
          @args = @args.map do |value|
            [[value.to_f, 255].min, 0].max
          end
        end
      end
    end
  end
end
