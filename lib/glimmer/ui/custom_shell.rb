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

require 'glimmer/ui'
require 'glimmer/error'

module Glimmer
  module UI
    module CustomShell
      include SuperModule
      include Glimmer::UI::CustomWidget
      
      class << self
        def launch(*args, &content)
          launched_custom_shell = send(keyword, *args, &content)
          auto_exec do
            launched_custom_shell.swt_widget.set_data('launched', true)
            launched_custom_shell.open
          end
        end
      end
      
      def initialize(parent, *swt_constants, options, &content)
        super
        auto_exec do
          @swt_widget.set_data('custom_shell', self)
          @swt_widget.set_data('custom_window', self)
        end
        raise Error, 'Invalid custom shell (window) body root! Must be a shell (window) or another custom shell (window).' unless body_root.swt_widget.is_a?(org.eclipse.swt.widgets.Shell)
      end
      
      # Classes may override
      def open
        body_root.open
      end

      # DO NOT OVERRIDE. JUST AN ALIAS FOR `#open`. OVERRIDE `#open` INSTEAD.
      def show
        open
      end

      # TODO consider using Forwardable instead
      def close
        body_root.close
      end

      def hide
        body_root.hide
      end

      def visible?
        body_root.visible?
      end

      def disposed?
        swt_widget.is_disposed
      end

      def center_within_display
        body_root.center_within_display
      end

      def start_event_loop
        body_root.start_event_loop
      end
    end
    CustomWindow = CustomShell
    Application = CustomShell
  end
end
