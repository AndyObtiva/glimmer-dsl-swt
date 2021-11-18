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

require 'glimmer-dsl-swt'

class Location
  attr_accessor :country
  
  def country_options
    %w[USA Canada Mexico Columbia UK Australia Germany Italy Spain]
  end
end

@location = Location.new

include Glimmer

shell {
  text 'Hello, Drag and Drop!'
  minimum_size 250, 100
  
  list {
    selection <=> [@location, :country]
    
    on_drag_set_data do |event|
      drag_widget = event.widget.control
      event.data = drag_widget.selection.first
    end
  }
  
  list {
    on_drop do |event|
      drop_widget = event.widget.control
      drop_widget.items += [event.data]
      drop_widget.select(drop_widget.items.count - 1)
    end
  }
}.open
