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

require_relative "contact_manager/contact_manager_presenter"

class ContactManager
  include Glimmer::UI::CustomShell

  before_body do
    @contact_manager_presenter = ContactManagerPresenter.new
    @contact_manager_presenter.list
  end

  body {
    shell {
      text "Contact Manager"
      composite {
        group {
          grid_layout(2, false) {
            margin_width 0
            margin_height 0
          }
          
          layout_data :fill, :center, true, false
          text 'Lookup Contacts'
          font height: 24
          
          label {
            layout_data :right, :center, false, false
            text "First &Name: "
            font height: 16
          }
          text {
            layout_data :fill, :center, true, false
            text <=> [@contact_manager_presenter, :first_name]
            
            on_key_pressed do |key_event|
              @contact_manager_presenter.find if key_event.keyCode == swt(:cr)
            end
          }
          
          label {
            layout_data :right, :center, false, false
            text "&Last Name: "
            font height: 16
          }
          text {
            layout_data :fill, :center, true, false
            text <=> [@contact_manager_presenter, :last_name]
            
            on_key_pressed do |key_event|
              @contact_manager_presenter.find if key_event.keyCode == swt(:cr)
            end
          }
          
          label {
            layout_data :right, :center, false, false
            text "&Email: "
            font height: 16
          }
          text {
            layout_data :fill, :center, true, false
            text <=> [@contact_manager_presenter, :email]
            
            on_key_pressed do |key_event|
              @contact_manager_presenter.find if key_event.keyCode == swt(:cr)
            end
          }
          
          composite {
            row_layout {
              margin_width 0
              margin_height 0
            }
            layout_data(:right, :center, false, false) {
              horizontal_span 2
            }
            
            button {
              text "&Create"
              
              on_widget_selected do
                create_contact
              end
              
              on_key_pressed do |key_event|
                create_contact if key_event.keyCode == swt(:cr)
              end
            }
            
            button {
              text "&Find"
              
              on_widget_selected do
                @contact_manager_presenter.find
              end
              
              on_key_pressed do |key_event|
                @contact_manager_presenter.find if key_event.keyCode == swt(:cr)
              end
            }
            
            button {
              text "&List All"
              
              on_widget_selected do
                @contact_manager_presenter.list
              end
              
              on_key_pressed do |key_event|
                @contact_manager_presenter.list if key_event.keyCode == swt(:cr)
              end
            }
          }
        }

        @table = table(:editable, :border) { |table_proxy|
          layout_data {
            horizontal_alignment :fill
            vertical_alignment :fill
            grab_excess_horizontal_space true
            grab_excess_vertical_space true
            height_hint 200
          }
          
          table_column {
            text "First Name"
            width 80
          }
          table_column {
            text "Last Name"
            width 80
          }
          table_column {
            text "Email"
            width 200
          }
          
          menu {
            menu_item {
              text '&Delete'
              
              on_widget_selected do
                @contact_manager_presenter.delete
              end
            }
          }
          
          items <=> [@contact_manager_presenter, :results]
          selection <=> [@contact_manager_presenter, :selected_contact]
          
          on_mouse_up do |event|
            table_proxy.edit_table_item(event.table_item, event.column_index)
          end
        }
      }
    }
  }
  
  def create_contact
    created_contact = @contact_manager_presenter.create
    new_item = @table.search do |table_item|
      model = table_item.data # get model embodied by table item
      created_contact == model
    end.first
    @table.setSelection(new_item) # set selection with Table SWT API
    @table.showSelection # show selection with Table SWT API
  end
end

ContactManager.launch
