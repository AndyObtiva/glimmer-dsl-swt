# Copyright (c) 2007-2025 Andy Maleh
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
    # Proxy for org.eclipse.swt.dnd.DND
    #
    # Follows the Proxy Design Pattern
    class DNDProxy
      include StyleConstantizable

      class << self
        JAVA_IMPORT = 'org.eclipse.swt.dnd.DND'
        
        java_import JAVA_IMPORT
        
        def constant_java_import
          JAVA_IMPORT
        end

        def constant_source_class
          DND
        end

        def constant_value_none
          DND::DROP_NONE
        end
      end
    end
  end
end
