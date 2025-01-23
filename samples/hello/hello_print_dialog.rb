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

require 'glimmer-dsl-swt'

class HelloPrintDialog
  include Glimmer::UI::CustomShell
  
  body {
    shell {
      text 'Hello, Print Dialog!'
      @composite = composite {
        row_layout(:vertical) {
          fill true
          center true
        }
        
        label(:center) {
          text "Whatever you see inside the app composite\nwill get printed when clicking the Print button."
          font height: 16
        }
         
        button {
          text 'Print'
          
          on_widget_selected do
            # note: you may check out Hello, Print! for a simpler version that automates the work below
            image = Image.new(display.swt_display, @composite.bounds)
            gc = org.eclipse.swt.graphics.GC.new(image)
            success = @composite.print(gc)
            if success
              printer_data = print_dialog.open
              if printer_data
                printer = Printer.new(printer_data)
                if printer.start_job('Glimmer')
                  printer_gc = org.eclipse.swt.graphics.GC.new(printer)
                  if printer.start_page
                    printer_gc.drawImage(image, 0, 0)
                    printer.end_page
                  else
                    message_box {
                      text 'Unable To Print'
                      message 'Sorry! Cannot start printer page!'
                    }.open
                  end
                  printer_gc.dispose
                  printer.end_job
                else
                  message_box {
                    text 'Unable To Print'
                    message 'Sorry! Cannot start printer job!'
                  }.open
                end
                printer.dispose
                gc.dispose
                image.dispose
              end
            else
              message_box {
                text 'Unable To Print'
                message 'Sorry! Printing is not supported on this platform!'
              }.open
            end
          end
        }
      }
    }
  }
end

HelloPrintDialog.launch
