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
        @cursor_style = cursor_style.to_s
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
