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

require 'date'
require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    # Proxy for org.eclipse.swt.widgets.DateTime
    #
    # Follows the Proxy Design Pattern
    class DateTimeProxy < WidgetProxy
      CUSTOM_ATTRIBUTES = %w[date_time date time month]
      
      def date_time
        DateTime.new(year, month, day, hours, minutes, seconds)
      end
      
      def date_time=(date_time_value)
        self.time = date_time_value.to_time
      end
      
      def date
        date_time.to_date
      end
      
      def date=(date_value)
        auto_exec do
          swt_widget.setDate(date_value.year, date_value.month - 1, date_value.day)
        end
      end
      
      def time
        date_time.to_time
      end
      
      def time=(time_value)
        self.date = time_value.to_date
        self.hours = time_value.hour
        self.minutes = time_value.min
        self.seconds = time_value.sec
      end
      
      def month
        auto_exec do
          swt_widget.month + 1
        end
      end
      
      def month=(new_value)
        auto_exec do
          swt_widget.month = new_value - 1
        end
      end
      
      def set_attribute(attribute_name, *args)
        if CUSTOM_ATTRIBUTES.include?(attribute_name.to_s)
          send(ruby_attribute_setter(attribute_name), args.first)
        else
          super(attribute_name, *args)
        end
      end
 
      def get_attribute(attribute_name)
        if CUSTOM_ATTRIBUTES.include?(attribute_name.to_s)
          send(attribute_name)
        else
          super(attribute_name)
        end
      end
    end
  end
end
