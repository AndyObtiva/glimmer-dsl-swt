# Copyright (c) 2007-2023 Andy Maleh
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

require 'glimmer/swt/style_constantizable'

module Glimmer
  module SWT
    # Proxy for org.eclipse.swt.SWT
    #
    # Follows the Proxy Design Pattern
    class SWTProxy
      include StyleConstantizable

      class << self
        JAVA_IMPORT = 'org.eclipse.swt.SWT'
        
        java_import JAVA_IMPORT
        
        def constant_java_import
          JAVA_IMPORT
        end

        def constant_source_class
          SWT
        end

        def constant_value_none
          SWT::NONE
        end
        
        def extra_styles
          EXTRA_STYLES
        end
        
        def cursor_styles
          SWT.constants.select {|c| c.to_s.start_with?('CURSOR_')}
        end
        
        def color_styles
          SWT.constants.select {|c| c.to_s.start_with?('COLOR_')}
        end
        
        def cursor_options
          cursor_styles.map {|c| c.to_s.sub('CURSOR_', '').downcase}.map(&:to_sym)
        end
        
        def color_options
          color_styles.map {|c| c.to_s.sub('COLOR_', '').downcase}.map(&:to_sym)
        end
      end
      
      EXTRA_STYLES = {
        NO_RESIZE: self[:shell_trim, :resize!, :max!],
        WINDOW_TRIM: self[:shell_trim],
      }
    end
  end
end
