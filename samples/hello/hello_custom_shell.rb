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

require 'glimmer-dsl-swt'
require 'date'

# This class declares an `email_shell` custom shell, aka custom window (by convention)
# Used to view an email message
class EmailShell
  # including Glimmer::UI::CustomShell enables declaring as an `email_shell` custom widget Glimmer GUI DSL keyword
  # Glimmer::UI::CustomShell is a specialized Glimmer::UI::CustomWidget that has `shell` as its `body_root`
  include Glimmer::UI::CustomShell # aliases: Glimmer::UI::CustomWindow & Glimmer::UI::Application
  
  # multiple options without default values
  options :parent_shell, :date, :subject, :from, :message
  
  # single option with default value
  option :to, default: '"John Irwin" <john.irwin@example.com>'
  
  before_body do
    # build a custom swt_style based on passed in swt style symbols (built-in CustomShell attribute)
    @swt_style = swt(:shell_trim, :modeless, *swt_style_symbols)
  end
  
  body {
    # pass received @swt_style through to shell to customize it (e.g. :dialog_trim for a blocking shell)
    shell(parent_shell, @swt_style) {
      grid_layout(2, false)
      
      text subject

      label {
        text 'Date:'
      }
      label {
        text date
      }

      label {
        text 'From:'
      }
      label {
        text from
      }

      label {
        text 'To:'
      }
      label {
        text to
      }

      label {
        text 'Subject:'
      }
      label {
        text subject
      }

      label {
        layout_data(:fill, :fill, true, true) {
          horizontal_span 2
          vertical_indent 10
        }
        
        background :white
        text message
      }
    }
  }
  
end

class HelloCustomShell
  include Glimmer::UI::Application # aliases: Glimmer::UI::CustomShell & Glimmer::UI::CustomWindow
  
  Email = Struct.new(:date, :subject, :from, :message, keyword_init: true)
  EmailSystem = Struct.new(:emails, :selected_email, keyword_init: true)
  
  before_body do
    @email_system = EmailSystem.new(
      emails: [
        Email.new(
          date: DateTime.new(2029, 10, 22, 11, 3, 0).strftime('%F %I:%M %p'),
          subject: '3rd Week Report',
          from: '"Dianne Tux" <dianne.tux@example.com>',
          message: "Hello,\n\nI was wondering if you'd like to go over the weekly report sometime this afternoon.\n\nDianne"
        ),
        Email.new(
          date: DateTime.new(2029, 10, 21, 8, 1, 0).strftime('%F %I:%M %p'),
          subject: 'Glimmer Upgrade v100.0',
          from: '"Robert McGabbins" <robert.mcgabbins@example.com>',
          message: "Team,\n\nWe are upgrading to Glimmer version 100.0.\n\nEveryone pull the latest code!\n\nRegards,\n\nRobert McGabbins"
        ),
        Email.new(
          date: DateTime.new(2029, 10, 19, 16, 58, 0).strftime('%F %I:%M %p'),
          subject: 'Christmas Party',
          from: '"Lisa Ferreira" <lisa.ferreira@example.com>',
          message: "Merry Christmas,\n\nAll office Christmas Party arrangements have been set\n\nMake sure to bring a Secret Santa gift\n\nBest regards,\n\nLisa Ferreira"
        ),
        Email.new(
          date: DateTime.new(2029, 10, 16, 9, 43, 0).strftime('%F %I:%M %p'),
          subject: 'Glimmer Upgrade v99.0',
          from: '"Robert McGabbins" <robert.mcgabbins@example.com>',
          message: "Team,\n\nWe are upgrading to Glimmer version 99.0.\n\nEveryone pull the latest code!\n\nRegards,\n\nRobert McGabbins"
        ),
        Email.new(
          date: DateTime.new(2029, 10, 15, 11, 2, 0).strftime('%F %I:%M %p'),
          subject: '2nd Week Report',
          from: '"Dianne Tux" <dianne.tux@example.com>',
          message: "Hello,\n\nI was wondering if you'd like to go over the weekly report sometime this afternoon.\n\nDianne"
        ),
        Email.new(
          date: DateTime.new(2029, 10, 2, 10, 34, 0).strftime('%F %I:%M %p'),
          subject: 'Glimmer Upgrade v98.0',
          from: '"Robert McGabbins" <robert.mcgabbins@example.com>',
          message: "Team,\n\nWe are upgrading to Glimmer version 98.0.\n\nEveryone pull the latest code!\n\nRegards,\n\nRobert McGabbins"
        ),
      ]
    )
  end
  
  body {
    shell {
      grid_layout
      
      text 'Hello, Custom Shell!'
      
      label {
        font height: 24, style: :bold
        text 'Emails:'
      }
      
      label {
        font height: 18
        text 'Click an email to view its message'
      }
      
      table {
        layout_data :fill, :fill, true, true
      
        table_column {
          text 'Date'
          width 180
        }
        table_column {
          text 'Subject'
          width 180
        }
        table_column {
          text 'From'
          width 360
        }
        
        items <=> [@email_system, :emails]
        selection <=> [@email_system, :selected_email]
        
        on_mouse_up do |event|
          open_email(@email_system.selected_email)
        end
        
        on_key_pressed do |event|
          if [swt(:cr), swt(:space)].include?(event.keyCode)
            open_email(@email_system.selected_email)
          end
        end
      }
    }
  }
  
  def open_email(email)
    return if email.nil?
    
    # open a custom email shell
    email_shell(
      parent_shell: body_root,
      date: email.date,
      subject: email.subject,
      from: email.from,
      message: email.message
    ).open
  end
end

HelloCustomShell.launch
