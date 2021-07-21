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

include Glimmer

# A version of this was featured in a dzone article as an intro to Glimmer syntax:
# https://dzone.com/articles/an-introduction-glimmer
shell { |shell_proxy|
  text "User Profile"

  composite {
    grid_layout 2, false

    group {
      text "Name"
      grid_layout 2, false
      layout_data :fill, :fill, true, true
      label {text "First"}; text {text "Bullet"}
      label {text "Last"}; text {text "Tooth"}
    }

    group {
      layout_data :fill, :fill, true, true
      text "Gender"
      radio {text "Male"; selection true}
      radio {text "Female"}
    }

    group {
      layout_data :fill, :fill, true, true
      text "Role"
      check {text "Student"; selection true}
      check {text "Employee"; selection true}
    }

    group {
      text "Experience"
      row_layout
      layout_data :fill, :fill, true, true
      spinner {selection 5}; label {text "years"}
    }

    button {
      text "save"
      layout_data :right, :center, true, true
      on_widget_selected {
        message_box {
          text 'Profile Saved!'
          message 'User profile has been saved!'
        }.open
      }
    }

    button {
      text "close"
      layout_data :left, :center, true, true
      on_widget_selected { shell_proxy.close }
    }
  }
}.open
