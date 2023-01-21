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

class LoginPresenter

  attr_accessor :user_name
  attr_accessor :password
  attr_accessor :status

  def initialize
    @user_name = ""
    @password = ""
    @status = "Logged Out"
  end

  def status=(status)
    @status = status
  end
  
  def valid?
    !@user_name.to_s.strip.empty? && !@password.to_s.strip.empty?
  end

  def logged_in?
    self.status == "Logged In"
  end

  def logged_out?
    !self.logged_in?
  end

  def login!
    return unless valid?
    self.status = "Logged In"
  end

  def logout!
    self.user_name = ""
    self.password = ""
    self.status = "Logged Out"
  end

end

class Login
  include Glimmer::UI::CustomShell

  before_body do
    @presenter = LoginPresenter.new
  end

  body {
    shell {
      text "Login"
      
      composite {
        grid_layout 2, false #two columns with differing widths

        label { text "Username:" } # goes in column 1
        @user_name_text = text {   # goes in column 2
          text <=> [@presenter, :user_name]
          enabled <= [@presenter, :logged_out?, computed_by: :status]
          
          on_key_pressed do |event|
            @password_text.set_focus if event.keyCode == swt(:cr)
          end
        }

        label { text "Password:" }
        @password_text = text(:password, :border) {
          text <=> [@presenter, :password]
          enabled <= [@presenter, :logged_out?, computed_by: :status]
          
          on_key_pressed do |event|
            @presenter.login! if event.keyCode == swt(:cr)
          end
        }

        label { text "Status:" }
        label { text <= [@presenter, :status] }

        button {
          text "Login"
          enabled <= [@presenter, :logged_out?, computed_by: :status]
          
          on_widget_selected do
            @presenter.login!
          end
          
          on_key_pressed do |event|
            if event.keyCode == swt(:cr)
              @presenter.login!
            end
          end
        }

        button {
          text "Logout"
          enabled <= [@presenter, :logged_in?, computed_by: :status]
          
          on_widget_selected do
            @presenter.logout!
          end
          
          on_key_pressed do |event|
            if event.keyCode == swt(:cr)
              @presenter.logout!
              @user_name_text.set_focus
            end
          end
        }
      }
    }
  }
end

Login.launch
