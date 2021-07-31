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

require_relative 'block'
require_relative 'playfield'

class Tetris
  module View
    class ScoreLane
      include Glimmer::UI::CustomWidget
  
      options :block_size, :game
      
      before_body do
        @font_name = FONT_NAME
        @font_height = FONT_TITLE_HEIGHT
      end
  
      body {
        composite {
          row_layout {
            type :vertical
            center true
            fill true
            margin_width 0
            margin_right block_size
            margin_height block_size
          }
          label(:center) {
            text 'Next'
            font name: @font_name, height: @font_height, style: FONT_TITLE_STYLE
          }
          playfield(game_playfield: game.preview_playfield, playfield_width: Model::Game::PREVIEW_PLAYFIELD_WIDTH, playfield_height: Model::Game::PREVIEW_PLAYFIELD_HEIGHT, block_size: block_size)

          label(:center) {
            text 'Score'
            font name: @font_name, height: @font_height, style: FONT_TITLE_STYLE
          }
          label(:center) {
            text <= [game, :score]
            font height: @font_height
          }
          
          label # spacer
          
          label(:center) {
            text 'Lines'
            font name: @font_name, height: @font_height, style: FONT_TITLE_STYLE
          }
          label(:center) {
            text <= [game, :lines]
            font height: @font_height
          }
          
          label # spacer
          
          label(:center) {
            text 'Level'
            font name: @font_name, height: @font_height, style: FONT_TITLE_STYLE
          }
          label(:center) {
            text <= [game, :level]
            font height: @font_height
          }
        }
      }
    end
  end
end
