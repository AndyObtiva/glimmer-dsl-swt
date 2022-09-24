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

require 'glimmer/swt/widget_proxy'
require 'glimmer/swt/swt_proxy'

module Glimmer
  module SWT
    # A proxy object representing SWT TableColumn
    # Accepts a :no_sort custom style to disable sorting on this column
    class TableColumnProxy < Glimmer::SWT::WidgetProxy
      attr_reader :sort_property, :editor
      attr_accessor :no_sort, :sort_block, :sort_by_block
      alias no_sort? no_sort
      
      def initialize(underscored_widget_name, parent, args)
        @no_sort = args.delete(:no_sort)
        super
        on_widget_selected do |event|
          parent.sort_by_column!(self) unless no_sort?
        end unless no_sort?
      end
      
      def sort_property=(args)
        @sort_property = args unless args.empty?
      end
      
      # Sets editor (e.g. combo)
      def editor=(args)
        @editor = args
      end
      
      def editable?
        !@editor&.include?(:none)
      end
      
    end
  end
end
