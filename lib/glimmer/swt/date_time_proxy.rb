# Copyright (c) 2007-2020 Andy Maleh
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

require 'glimmer/swt/widget_proxy'

module Glimmer
  module SWT
    # Proxy for org.eclipse.swt.widgets.DateTime
    #
    # Follows the Proxy Design Pattern
    class DateTimeProxy < WidgetProxy
      def date_time
        Time.new(year, month, day, hours, minutes, seconds)
      end
      
      def date_time=(date_time_value)
        date_time_value = date_time_value.first if date_time_value.is_a?(Array)
        self.year = date_time_value.year
        self.month = date_time_value.month
        self.day = date_time_value.day
        self.hours = date_time_value.hour
        self.minutes = date_time_value.min
        self.seconds = date_time_value.sec
      end
      
      def set_attribute(attribute_name, *args)
        if attribute_name.to_s == 'month'
          swt_widget.month = args.first - 1
        else
          super(attribute_name, *args)
        end
      end
 
      def get_attribute(attribute_name)
        if attribute_name.to_s == 'month'
          swt_widget.month + 1
        else
          super(attribute_name)
        end
      end
    end
  end
end
