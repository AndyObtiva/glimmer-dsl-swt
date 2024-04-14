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
    # Proxy for org.eclipse.swt.graphics.Cursor
    #
    # Invoking `#swt_cursor` returns the SWT Cursor object wrapped by this proxy
    #
    # Follows the Proxy Design Pattern
    class CursorProxy
      CURSOR_STYLES = org.eclipse.swt.SWT.constants.select {|c| c.to_s.downcase.start_with?('cursor_')}.map {|c| c.to_s.downcase.sub('cursor_', '').to_sym}
      ERROR_INVALID_CURSOR_STYLE = " is an invalid cursor style! Valid values are #{CURSOR_STYLES.map(&:to_s).join(", ")}"

      include_package 'org.eclipse.swt.graphics'

      attr_reader :swt_cursor, :cursor_style

      # Builds a new CursorProxy from passed in cursor SWT style (e.g. :appstarting, :hand, or :help)
      #
      # Cursor SWT styles are those that begin with "CURSOR_" prefix
      #
      # They are expected to be passed in in short form without the prefix (but would work with the prefix too)
      def initialize(cursor_style)
        @cursor_style = cursor_style
        @cursor_style = SWTProxy.reverse_lookup(@cursor_style).detect { |symbol| symbol.to_s.downcase.start_with?('cursor_') } if cursor_style.is_a?(Integer)
        @cursor_style = @cursor_style.to_s.downcase
        @cursor_style = @cursor_style.sub(/^cursor\_/, '') if @cursor_style.start_with?('cursor_')
        detect_invalid_cursor_style
        @swt_cursor = DisplayProxy.instance.swt_display.get_system_cursor(SWTProxy[swt_style])
      end
      
      def swt_style
        @swt_style ||= @cursor_style.upcase.start_with?('CURSOR_') ? @cursor_style : "CURSOR_#{@cursor_style}"
      end

      private

      def detect_invalid_cursor_style
        raise Error, cursor_style.to_s + ERROR_INVALID_CURSOR_STYLE unless CURSOR_STYLES.include?(cursor_style.to_s.downcase.to_sym)
      end
    end
  end
end
