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

require 'glimmer/dsl/static_expression'
require 'glimmer/dsl/parent_expression'
require 'glimmer/dsl/top_level_expression'
require 'glimmer/swt/file_dialog_proxy'

module Glimmer
  module DSL
    module SWT
      class FileDialogExpression < StaticExpression
        include TopLevelExpression
        include ParentExpression
        
        include_package 'org.eclipse.swt.widgets'

        def can_interpret?(parent, keyword, *args, &block)
          keyword == 'file_dialog' and
            (parent.nil? or parent.is_a?(Shell) or parent.is_a?(Glimmer::SWT::ShellProxy))
        end
  
        def interpret(parent, keyword, *args, &block)
          args = [parent] + args unless parent.nil?
          Glimmer::SWT::FileDialogProxy.send(:new, *args)
        end
      end
    end
  end
end
