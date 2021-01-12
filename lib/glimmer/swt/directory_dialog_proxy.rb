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

require 'glimmer/swt/swt_proxy'
require 'glimmer/swt/widget_proxy'
require 'glimmer/swt/display_proxy'

module Glimmer
  module SWT
    # Proxy for org.eclipse.swt.widgets.DirectoryDialog
    #
    # Automatically uses the current shell if one is open.
    # Otherwise, it instantiates a new shell parent
    #
    # Optionally takes a shell as an argument
    #
    # Follows the Proxy Design Pattern
    class DirectoryDialogProxy < WidgetProxy
      # TODO write rspec tests
      include_package 'org.eclipse.swt.widgets'

      def initialize(*args, swt_widget: nil)
        if swt_widget
          @swt_widget = swt_widget
        else
          style_args = args.select {|arg| arg.is_a?(Symbol) || arg.is_a?(String)}
          if style_args.any?
            style_arg_start_index = args.index(style_args.first)
            style_arg_last_index = args.index(style_args.last)
            args[style_arg_start_index..style_arg_last_index] = SWTProxy[style_args]
          end
          if !args.first.is_a?(Shell)
            current_shell = DisplayProxy.instance.swt_display.shells.first
            args.unshift(current_shell.nil? ? ShellProxy.new : current_shell)
          end
          if args.first.is_a?(ShellProxy)
            args[0] = args[0].swt_widget
          end
          parent = args[0]
          @parent_proxy = parent.is_a?(Shell) ? ShellProxy.new(swt_widget: parent) : parent
          @swt_widget = DirectoryDialog.new(*args)
        end
      end

    end
  end
end
