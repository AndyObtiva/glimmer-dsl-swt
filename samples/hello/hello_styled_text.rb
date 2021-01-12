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

verbiage = <<-MULTI_LINE_STRING

Glimmer DSL for SWT is a native-GUI cross-platform desktop development library written in JRuby, 
an OS-threaded faster version of Ruby. 
Glimmer's main innovation is a declarative Ruby DSL that enables productive and efficient authoring 
of desktop application user-interfaces while relying on the robust Eclipse SWT library. 
Glimmer additionally innovates by having built-in data-binding support, which greatly facilitates 
synchronizing the GUI with domain models, thus achieving true decoupling of object oriented components 
and enabling developers to solve business problems (test-first) without worrying about GUI concerns. 
To get started quickly, Glimmer offers scaffolding options for Apps, Gems, and Custom Widgets. 
Glimmer also includes native-executable packaging support, sorely lacking in other libraries, 
thus enabling the delivery of desktop apps written in Ruby as truly native DMG/PKG/APP files on 
the Mac + App Store, MSI/EXE files on Windows, and Gem Packaged Shell Scripts on Linux.

MULTI_LINE_STRING

class StyledTextPresenter
  include Glimmer
  attr_accessor :text, :caret_offset, :selection_count, :selection, :top_pixel
    
  def line_index_for_offset(line_offset)
    text[0..line_offset].split("\n").size
  end
end

include Glimmer

@presenter = StyledTextPresenter.new
@presenter.text = verbiage*8
@presenter.caret_offset = 0
@presenter.selection_count = 0
@presenter.selection = Point.new(0, 0)
@presenter.top_pixel = 0

shell {
  text 'Hello, Styled Text!'
  
  composite {
    @styled_text = styled_text {
      layout_data :fill, :fill, true, true
      text bind(@presenter, :text)
      left_margin 5
      top_margin 5
      right_margin 5
      bottom_margin 5
      # caret offset scrolls text to view when out of page
      caret_offset bind(@presenter, :caret_offset)
      # selection_count is not needed if selection is used
      selection_count bind(@presenter, :selection_count)
      # selection contains both caret_offset and selection_count, but setting it does not scroll text into view if out of page
      selection bind(@presenter, :selection)
      # top_pixel indicates vertically what pixel scrolling is at in a long multi-page text document
      top_pixel bind(@presenter, :top_pixel)
      
      # This demonstrates how to set styles via a listener
      on_line_get_style { |line_style_event|        
        line_offset = line_style_event.lineOffset
        if @presenter.line_index_for_offset(line_offset) % 52 < 13
          line_size = line_style_event.lineText.size
          style_range = StyleRange.new(line_offset, line_size, color(:blue).swt_color, nil, swt(:italic))
          style_range.font = Font.new(display.swt_display, 'Times New Roman', 18, swt(:normal))
          line_style_event.styles = [style_range].to_java(StyleRange)
        elsif @presenter.line_index_for_offset(line_offset) % 52 < 26
          line_size = line_style_event.lineText.size
          style_range = StyleRange.new(line_offset, line_size, color(:dark_green).swt_color, color(:yellow).swt_color, swt(:bold))
          line_style_event.styles = [style_range].to_java(StyleRange)
        elsif @presenter.line_index_for_offset(line_offset) % 52 < 39
          line_size = line_style_event.lineText.size
          style_range = StyleRange.new(line_offset, line_size, color(:red).swt_color, nil, swt(:normal))
          style_range.underline = true
          style_range.font = Font.new(display.swt_display, 'Arial', 16, swt(:normal))
          line_style_event.styles = [style_range].to_java(StyleRange)
        else
          line_size = line_style_event.lineText.size
          style_range = StyleRange.new(line_offset, line_size, color(:dark_magenta).swt_color, color(:cyan).swt_color, swt(:normal))
          style_range.strikeout = true
          line_style_event.styles = [style_range].to_java(StyleRange)        
        end
      }
    }
    
    composite {
      row_layout :horizontal
      
      label {
        text 'Caret Offset:'
      }
      text {
        text bind(@presenter, :caret_offset, on_read: ->(o) {"%04d" % [o] })
      }
      label {
        text 'Selection Count:'
      }
      text {
        text bind(@presenter, :selection_count, on_read: ->(o) {"%04d" % [o] })
      }
      label {
        text 'Selection Start:'
      }
      text {
        text bind(@presenter, 'selection.x', on_read: ->(o) {"%04d" % [o] })
      }
      label {
        text 'Selection End:'
      }
      text {
        text bind(@presenter, 'selection.y', on_read: ->(o) {"%04d" % [o] })
      }
      label {
        text 'Top Pixel:'
      }
      text {
        text bind(@presenter, :top_pixel, on_read: ->(o) {"%04d" % [o] })
      }      
    }    
  }
}.open
