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

class Quarto
  module View
    class MessageBoxPanel
      include Glimmer::UI::CustomShape
      
      FONT_HEIGHT_DEFAULT = 12
      BUTTON_TEXT_DEFAULT = 'OK'
      
      option :message
      option :location_x, default: :default
      option :location_y, default: :default
      option :size_width
      option :size_height
      option :background_color, default: :white
      option :foreground_color, default: :black
      option :border_line_width, default: 1
      option :text_font, default: {height: FONT_HEIGHT_DEFAULT}
      option :text_color, default: :black
      
      attr_reader :closed
      alias closed? closed
      
      def can_handle_observation_request?(observation_request)
        observation_request == 'on_closed' || super
      end
      
      def handle_observation_request(observation_request, &block)
        if observation_request == 'on_closed'
          @on_closed_handlers ||= []
          @on_closed_handlers << block
        else
          super
        end
      end
      
      before_body do
        @font_height = text_font[:height] || FONT_HEIGHT_DEFAULT
        self.size_width ||= [:default, @font_height*4.0]
        self.size_height ||= [:default, @font_height*4.0]
        @text_offset = -1.2*@font_height
        
        display {
          on_swt_keyup do |key_event|
            close if key_event.keyCode == swt(:cr)
          end
        }
      end
      
      body {
        rectangle(location_x, location_y, size_width, size_height, round: true) {
          background background_color
                      
          text(message, :default, [:default, @text_offset]) {
            foreground :black
            font text_font
          }
          
          rectangle(0, 0, :max, :max, round: true) { # border drawn around max dimensions of parent
            foreground foreground_color
            line_width border_line_width
          }
          
          rectangle(:default, [:default, @font_height + (@font_height/2.0)], @font_height*5.5, @font_height*2.0, @font_height, @font_height, round: true) {
            background background_color

            text(BUTTON_TEXT_DEFAULT) {
              foreground text_color
              font text_font
            }
            
            on_mouse_up do
              close
            end
          }
          
          rectangle(:default, [:default, @font_height + (@font_height/2.0)], @font_height*5.5, @font_height*2.0, @font_height, @font_height, round: true) { # border
            foreground foreground_color
            line_width border_line_width
          }
        }
      }
      
      def close
        unless @closed
          @closed = true
          @on_closed_handlers&.each {|handler| handler.call}
          @on_closed_handlers&.clear
          body_root.dispose
        end
      end
    end
  end
end
