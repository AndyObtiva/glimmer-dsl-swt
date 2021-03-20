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

class HelloCTab
  include Glimmer::UI::CustomShell
  
  body {
    shell {
      row_layout
      text 'Hello, C Tab!'
      minimum_size 200, 200
      
      c_tab_folder { # accepts styles: :close, :top, :bottom, :flat, :border, :single, :multi
        layout_data {
          width 1024
        }
        c_tab_item(:close) {
          text 'English'
          tool_tip_text 'English Greeting'
          foreground :blue
          selection_foreground :dark_blue
          font name: 'Times New Roman', height: 30, style: [:bold, :italic]
          image image(30, 30) {
            ### building image on the fly with Canvas Shape DSL text shape flag emoji
            text('🇺🇸', 0, 0) {
              font name: 'Times New Roman', height: 30, style: [:bold, :italic]
            }
          }
          
          label {
            text 'Hello, World!'
            font name: 'Times New Roman', height: 90, style: [:bold, :italic]
          }
        }
        
        c_tab_item(:close) {
          text 'French'
          tool_tip_text 'French Greeting'
          foreground :blue
          selection_foreground :dark_blue
          font name: 'Times New Roman', height: 30, style: [:bold, :italic]
          image image(30, 30) {
            ### building image on the fly with Canvas Shape DSL text shape flag emoji
            text('🇫🇷', 0, 0) {
              font name: 'Times New Roman', height: 30, style: [:bold, :italic]
            }
          }
          
          label {
            text 'Bonjour, Univers!'
            font name: 'Times New Roman', height: 90, style: [:bold, :italic]
          }
        }
        
        c_tab_item(:close) {
          text 'Spanish'
          tool_tip_text 'Spanish Greeting'
          foreground :blue
          selection_foreground :dark_blue
          font name: 'Times New Roman', height: 30, style: [:bold, :italic]
          image image(30, 30) {
            ### building image on the fly with Canvas Shape DSL text shape flag emoji
            text('🇪🇸', 0, 0) {
              font name: 'Times New Roman', height: 30, style: [:bold, :italic]
            }
          }
          
          label {
            text 'Hola, Mundo!'
            font name: 'Times New Roman', height: 90, style: [:bold, :italic]
          }
        }
        
        c_tab_item(:close) {
          text 'German'
          tool_tip_text 'German Greeting'
          foreground :blue
          selection_foreground :dark_blue
          font name: 'Times New Roman', height: 30, style: [:bold, :italic]
          image image(30, 30) {
            # building image on the fly with Canvas Shape DSL text shape flag emoji
            text('🇩🇪', 0, 0) {
              font name: 'Times New Roman', height: 30, style: [:bold, :italic]
            }
          }

          label {
            text 'Hallo, Welt!'
            font name: 'Times New Roman', height: 90, style: [:bold, :italic]
          }
        }

        c_tab_item(:close) {
          text 'Italian'
          tool_tip_text 'Italian Greeting'
          foreground :blue
          selection_foreground :dark_blue
          font name: 'Times New Roman', height: 30, style: [:bold, :italic]
          image image(30, 30) {
            # building image on the fly with Canvas Shape DSL text shape flag emoji
            text('🇮🇹', 0, 0) {
              font name: 'Times New Roman', height: 30, style: [:bold, :italic]
            }
          }

          label {
            text 'Ciao, Mondo!'
            font name: 'Times New Roman', height: 90, style: [:bold, :italic]
          }
        }

        c_tab_item(:close) {
          text 'Dutch'
          tool_tip_text 'Dutch Greeting'
          foreground :blue
          selection_foreground :dark_blue
          font name: 'Times New Roman', height: 30, style: [:bold, :italic]
          image image(30, 30) {
            # building image on the fly with Canvas Shape DSL text shape flag emoji
            text('🇳🇱', 0, 0) {
              font name: 'Times New Roman', height: 30, style: [:bold, :italic]
            }
          }

          label {
            text 'Hallo, Wereld!'
            font name: 'Times New Roman', height: 90, style: [:bold, :italic]
          }
        }

        c_tab_item(:close) {
          text 'Portuguese'
          tool_tip_text 'Portuguese Greeting'
          foreground :blue
          selection_foreground :dark_blue
          font name: 'Times New Roman', height: 30, style: [:bold, :italic]
          image image(30, 30) {
            # building image on the fly with Canvas Shape DSL text shape flag emoji
            text('🇧🇷', 0, 0) {
              font name: 'Times New Roman', height: 30, style: [:bold, :italic]
            }
          }

          label {
            text 'Hello, Gifu!'
            font name: 'Times New Roman', height: 90, style: [:bold, :italic]
          }
        }

        c_tab_item(:close) {
          text 'Danish'
          tool_tip_text 'Danish Greeting'
          foreground :blue
          selection_foreground :dark_blue
          font name: 'Times New Roman', height: 30, style: [:bold, :italic]
          image image(30, 30) {
            # building image on the fly with Canvas Shape DSL text shape flag emoji
            text('🇩🇰', 0, 0) {
              font name: 'Times New Roman', height: 30, style: [:bold, :italic]
            }
          }

          label {
            text 'Hej, Verden!'
            font name: 'Times New Roman', height: 90, style: [:bold, :italic]
          }
        }

        c_tab_item(:close) {
          text 'Finnish'
          tool_tip_text 'Finnish Greeting'
          foreground :blue
          selection_foreground :dark_blue
          font name: 'Times New Roman', height: 30, style: [:bold, :italic]
          image image(30, 30) {
            # building image on the fly with Canvas Shape DSL text shape flag emoji
            text('🇫🇮', 0, 0) {
              font name: 'Times New Roman', height: 30, style: [:bold, :italic]
            }
          }

          label {
            text 'Hei, Maailma!'
            font name: 'Times New Roman', height: 90, style: [:bold, :italic]
          }
        }

        c_tab_item(:close) {
          text 'Swedish'
          tool_tip_text 'Swedish Greeting'
          foreground :blue
          selection_foreground :dark_blue
          font name: 'Times New Roman', height: 30, style: [:bold, :italic]
          image image(30, 30) {
            # building image on the fly with Canvas Shape DSL text shape flag emoji
            text('🇸🇪', 0, 0) {
              font name: 'Times New Roman', height: 30, style: [:bold, :italic]
            }
          }

          label {
            text 'Hej, Världen!'
            font name: 'Times New Roman', height: 90, style: [:bold, :italic]
          }
        }

        c_tab_item(:close) {
          text 'Norwegian'
          tool_tip_text 'Norwegian Greeting'
          foreground :blue
          selection_foreground :dark_blue
          font name: 'Times New Roman', height: 30, style: [:bold, :italic]
          image image(30, 30) {
            # building image on the fly with Canvas Shape DSL text shape flag emoji
            text('🇳🇴', 0, 0) {
              font name: 'Times New Roman', height: 30, style: [:bold, :italic]
            }
          }

          label {
            text 'Hei, Verden!'
            font name: 'Times New Roman', height: 90, style: [:bold, :italic]
          }
        }

        c_tab_item(:close) {
          text 'Russian'
          tool_tip_text 'Russian Greeting'
          foreground :blue
          selection_foreground :dark_blue
          font name: 'Times New Roman', height: 30, style: [:bold, :italic]
          image image(30, 30) {
            # building image on the fly with Canvas Shape DSL text shape flag emoji
            text('🇷🇺', 0, 0) {
              font name: 'Times New Roman', height: 30, style: [:bold, :italic]
            }
          }

          label {
            text 'Привет, мир!'
            font name: 'Times New Roman', height: 90, style: [:bold, :italic]
          }
        }

      }
    }
  }
end

HelloCTab.launch
