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
  
  tab_folder {
    tab_item {
      fill_layout
      text 'List'
      
      list {
        selection <=> [@location, :country]
        
        # Option 1: Automatic Drag Data Setting
        drag_source true
        
        # Option 2: Manual Drag Data Setting
#         on_drag_set_data do |event|
#           drag_widget = event.widget.control
#           event.data = drag_widget.selection.first
#         end
        
        # Option 3: Full Customization of Drag Source (details at:  https://www.eclipse.org/articles/Article-SWT-DND/DND-in-SWT.html)
#         drag_source(:drop_copy) { # options: :drop_copy, :drop_link, :drop_move, :drop_target_move
#           transfer :text # options: :text, :file, :rtf
#
#           on_drag_start do |event|
#             drag_widget = event.widget.control.data('proxy') # obtain Glimmer widget proxy since it permits nicer syntax for setting cursor via symbol
#             drag_widget.cursor = :wait
#           end
#
#           on_drag_set_data do |event|
#             drag_widget = event.widget.control
#             event.data = drag_widget.selection.first
#           end
#
#           on_drag_finished do |event|
#             drag_widget = event.widget.control.data('proxy') # obtain Glimmer widget proxy since it permits nicer syntax for setting cursor via symbol
#             drag_widget.cursor = :arrow
#           end
#         }
      }
      
      list {
        # Option 1: Automatic Drop Data Consumption
        drop_target true
#         drop_target :unique # setting drop_target to :unique makes the list not add the same data twice
        
        # Option 2: Manual Drop Data Consumption
#         on_drop do |event|
#           drop_widget = event.widget.control
#           drop_widget.add(event.data)
#           drop_widget.select(drop_widget.items.count - 1)
#         end
        
        # Option 3: Full Customization of Drop Target (details at:  https://www.eclipse.org/articles/Article-SWT-DND/DND-in-SWT.html)
#         drop_target(:drop_copy) { # options: :drop_copy, :drop_link, :drop_move, :drop_target_move
#           transfer :text # options: :text, :file, :rtf
#
#           on_drag_enter do |event|
#             ### event.detail = DND::DROP_NONE # To reject a drop, you can set event.detail to DND::DROP_NONE
#             drop_widget = event.widget.control.data('proxy') # obtain Glimmer widget proxy since it permits nicer syntax for setting background via symbol
#             drop_widget.background = :red
#           end
#
#           on_drag_leave do |event|
#             drop_widget = event.widget.control.data('proxy') # obtain Glimmer widget proxy since it permits nicer syntax for setting background via symbol
#             drop_widget.background = :white
#           end
#
#           on_drop do |event|
#             drop_widget = event.widget.control.data('proxy') # obtain Glimmer widget proxy since it permits nicer syntax for setting background/cursor via symbol
#             drop_widget.background = :white
#             drop_widget.add(event.data)
#             drop_widget.select(drop_widget.items.count - 1)
#             drop_widget.cursor = :arrow
#           end
#         }
      }
    }
    
    tab_item {
      grid_layout 2, true
      text 'Label'
      
      label {
        layout_data {
          horizontal_span 2
        }
        text 'Drag text from any label and drop it unto another label'
      }
      
      {
        Argentina: :green,
        Brazil: :red,
        Finland: :yellow,
        Sweden: :magenta,
        Denmark: :gray,
        Iceland: :cyan
      }.each do |country, color|
        label {
          layout_data :fill, :fill, true, true
          text country
          font height: 20
          background color
          drag_source true
          drop_target true
        }
      end
    }
    
    tab_item {
      grid_layout 2, true
      text 'Text'
      
      label {
        text 'Drag'
      }
      
      label {
        text 'Drop To Insert'
      }
      
      text {
        layout_data :fill, :center, true, false
        text 'Text1'
        drag_source true
      }
      
      text {
        layout_data :fill, :center, true, false
        text 'Drop To Insert'
        drop_target true
      }
      
      label {
        text 'Drag'
      }
      
      label {
        text 'Drop To Replace'
      }
      
      text {
        layout_data :fill, :center, true, false
        text 'Text2'
        drag_source true
      }
      
      text {
        layout_data :fill, :center, true, false
        text 'Drop To Replace'
        drop_target :replace
      }
    }
    
    tab_item {
      grid_layout 2, true
      text 'Spinner'
      
      label {
        text 'Drag'
      }
      
      label {
        text 'Drop To Replace'
      }
      
      spinner {
        layout_data :fill, :center, true, false
        selection 30
        drag_source true
      }
      
      spinner {
        layout_data :fill, :center, true, false
        drop_target true
      }
    }
    tab_item {
      fill_layout
      text 'File'
      
      @drop_zone_label = label(:center, :wrap) {
        text 'Drop One File Or More Here'
        background :white
        
        rectangle  {
          foreground :black
          line_width 4
          line_style :dash
        }
        
        drop_target(:drop_copy) {
          transfer :file
          
          on_drag_enter do |event|
            drop_widget = event.widget.control.data('proxy') # obtain Glimmer widget proxy since it permits nicer syntax for setting background via symbol
            drop_widget.background = :yellow
          end

          on_drag_leave do |event|
            drop_widget = event.widget.control.data('proxy') # obtain Glimmer widget proxy since it permits nicer syntax for setting background via symbol
            drop_widget.background = :white
          end
          
          on_drop do |event|
            drop_widget = event.widget.control.data('proxy') # obtain Glimmer widget proxy since it permits nicer syntax for setting background/cursor via symbol
            drop_widget.background = :white
            @drop_zone_label.text = event.data.to_a.join("\n")
          end
        }
      }
    }
  }
}.open
