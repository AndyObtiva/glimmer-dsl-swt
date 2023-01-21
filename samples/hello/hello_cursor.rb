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

require 'glimmer-dsl-swt'

class HelloCursor
  include Glimmer::UI::CustomShell

  attr_accessor :selected_cursor

  # This method matches the name of the :selected_cursor property by convention
  def selected_cursor_options
    Glimmer::SWT::SWTProxy.cursor_options
  end

  before_body do
    self.selected_cursor = :arrow
  end

  body {
    shell {
      grid_layout

      text 'Hello, Cursor!'
      cursor <= [self, :selected_cursor]

      label {
        text 'Please select a cursor style and see it change the mouse cursor (varies per platform):'
        font style: :bold
        cursor :no
      }
      radio_group {
        grid_layout 5, true
        selection <=> [self, :selected_cursor]
      }
    }
  }
end

HelloCursor.launch
