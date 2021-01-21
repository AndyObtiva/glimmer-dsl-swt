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

module Tetris
  class Model
    class Block
      attr_reader :letter
      
      def initialize(letter = nil)
        @letter = letter
      end
    end
    class Row
      def blocks
        [Block.new]*10
      end
    end
    class << self
      def rows
        [Row.new]*20
      end
    end
  end
  
  class View
    include Glimmer::UI::CustomShell
    
    class Block
      include Glimmer::UI::CustomWidget
      
      options :block_color, :block_size
      
      body {
        canvas {
          rectangle(0, 0, block_size, block_size, fill: true) {
            background block_color
          }
          rectangle(0, 0, block_size, block_size)
        }
      }
    end
    
    class TetriminoI
      include Glimmer::UI::CustomWidget
      
      COLOR = :cyan
      
      options :orientation
      
      body {
        canvas {
          
        }
      }
    end
    
    class TetriminoJ
      include Glimmer::UI::CustomWidget
      
      COLOR = :blue
      
      options :orientation
      
      body {
        canvas {
          
        }
      }
    end
    
    class TetriminoL
      include Glimmer::UI::CustomWidget
      
      COLOR = :dark_yellow
      
      options :orientation
      
      body {
        canvas {
          
        }
      }
    end
    
    class TetriminoO
      include Glimmer::UI::CustomWidget
      
      COLOR = :yellow
      
      options :orientation
      
      body {
        canvas {
          
        }
      }
    end
    
    class TetriminoS
      include Glimmer::UI::CustomWidget
      
      COLOR = :green
      
      options :orientation
      
      body {
        canvas {
          
        }
      }
    end
    
    class TetriminoT
      include Glimmer::UI::CustomWidget
      
      COLOR = :magenta
      
      options :orientation
      
      body {
        canvas {
          
        }
      }
    end
    
    class TetriminoZ
      include Glimmer::UI::CustomWidget
      
      COLOR = :red
      
      options :orientation
      
      body {
        canvas {
          
        }
      }
    end
    
    body {
      shell {
        text 'Tetris'
        
        canvas {
          grid_layout(10, true) {
            margin_width 0
            margin_height 0
            horizontal_spacing 0
            vertical_spacing 0
          }
          
          Tetris::Model.rows.each { |row|
            row.blocks.each { |block|
              block_color = block.letter.nil? ? :gray : Tetris::View.const_get("Tetrimino#{block.letter}".to_sym)
              block_size = 25
              block(block_color: block_color, block_size: block_size) {
                layout_data {
                  width_hint block_size
                  height_hint block_size
                }
              }
            }
          }
        }
      }
    }
  end
end

Tetris::View.launch
