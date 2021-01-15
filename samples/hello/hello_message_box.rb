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

include Glimmer

shell {
  row_layout(:vertical) {
    center true
  }
  text 'Hello, Message Box!'
  
  button {
    text 'Please Click To Learn the Weather'
    
    on_widget_selected {
      message_box(:icon_information) {
        text 'Weather'
        message "The weather is sunny and warm!"
      }.open
    }
  }
  
  button {
    text 'Please Click To Confirm Terms and Conditions'
      
    on_widget_selected {
      result = message_box(:icon_question, :yes, :no) {
        text 'Terms and Conditions'
        message "Do you want to accept our terms and conditions?"
      }.open
      if result == swt(:yes)
        message_box {
          text 'Terms and Conditions'
          message "Thank you for accepting our terms and conditions!"
        }.open
      else
        message_box {
          text 'Terms and Conditions'
          message "Sorry to see you go!"
        }.open
      end
    }
  }
  
  button {
    text 'Please Click To Try Winning a Prize'
    
    on_widget_selected {
      result = nil
      while result.nil? || result == swt(:retry)
        win = (rand * 3).to_i == 0
        if win && !result.nil? # always fail the first time
          result = message_box {
            text 'Prize'
            message "Congratulations!\n\nYou won $1,000,000!"
          }.open
        else
          result = message_box(:icon_error, :retry, :cancel) {
            text 'Prize'
            message "Sorry, no prize!\n\nPlease try again!"
          }.open
        end
      end
    }
  }
  
  button {
    text 'Please Click To Connect To Internet'
    
    on_widget_selected {
      result = nil
      while result.nil? || result == swt(:retry)
        connection_success = (rand * 3).to_i > 0
        if connection_success && !result.nil? # always fail the first time
          result = message_box(:icon_working) {
            text 'Internet Connection Status'
            message "Success!\n\nInternet is now connected."
          }.open
        else
          result = message_box(:icon_error, :retry, :ignore, :abort) {
            text 'Internet Connection Status'
            message "Error connecting to network!\n\nMake sure modem cable is plugged in."
          }.open
        end
      end
    }
  }
    
}.open
