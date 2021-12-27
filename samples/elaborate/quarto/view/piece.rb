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

class Quarto
  module View
    class Piece
      include Glimmer::UI::CustomShape
      
      HEIGHT = 28
      TOP_WIDTH = HEIGHT
      TOP_HEIGHT = HEIGHT
      
      options :game, :model, :piece_x, :piece_y
      
      before_body do
        @background_color = model.light? ? COLOR_LIGHT_WOOD : COLOR_DARK_WOOD
      end
      
      body {
        shape(piece_x, piece_y) {
          if model.is_a?(Model::Piece::Cylinder)
            oval(0, HEIGHT, TOP_WIDTH, TOP_HEIGHT) {
              background @background_color
              oval # draws with foreground :black and has max size within parent by default
            }
            rectangle(0, TOP_HEIGHT / 2.0, TOP_WIDTH, HEIGHT) {
              background @background_color
            }
            polyline(0, TOP_HEIGHT / 2.0 + HEIGHT, 0, TOP_HEIGHT / 2.0, TOP_WIDTH, TOP_HEIGHT / 2.0, TOP_WIDTH, TOP_HEIGHT / 2.0 + HEIGHT)
            oval(0, 0, TOP_WIDTH, TOP_HEIGHT) {
              background @background_color
              oval # draws with foreground :black and has max size within parent by default
            }
            if model.pitted?
              oval(TOP_WIDTH / 4.0 + 1, TOP_HEIGHT / 4.0 + 1, TOP_WIDTH / 2.0, TOP_HEIGHT / 2.0) {
                background :black
              }
            end
          else
            polygon(0, HEIGHT + TOP_HEIGHT / 2.0, TOP_WIDTH / 2.0, HEIGHT, TOP_WIDTH, HEIGHT + TOP_HEIGHT / 2.0, TOP_WIDTH / 2.0, HEIGHT + TOP_HEIGHT) {
              background @background_color
            }
            polygon(0, HEIGHT + TOP_HEIGHT / 2.0, TOP_WIDTH / 2.0, HEIGHT, TOP_WIDTH, HEIGHT + TOP_HEIGHT / 2.0, TOP_WIDTH / 2.0, HEIGHT + TOP_HEIGHT)
            rectangle(0, TOP_HEIGHT / 2.0, TOP_WIDTH, HEIGHT) {
              background @background_color
            }
            polyline(0, TOP_HEIGHT / 2.0 + HEIGHT, 0, TOP_HEIGHT / 2.0, TOP_WIDTH, TOP_HEIGHT / 2.0, TOP_WIDTH, TOP_HEIGHT / 2.0 + HEIGHT)
            polygon(0, TOP_HEIGHT / 2.0, TOP_WIDTH / 2.0, 0, TOP_WIDTH, TOP_HEIGHT / 2.0, TOP_WIDTH / 2.0, TOP_HEIGHT) {
              background @background_color
            }
            polygon(0, TOP_HEIGHT / 2.0, TOP_WIDTH / 2.0, 0, TOP_WIDTH, TOP_HEIGHT / 2.0, TOP_WIDTH / 2.0, TOP_HEIGHT)
            line(TOP_WIDTH / 2.0, HEIGHT + TOP_HEIGHT, TOP_WIDTH / 2.0, TOP_HEIGHT)
            if model.pitted?
              oval(TOP_WIDTH / 4.0 + 1, TOP_HEIGHT / 4.0 + 1, TOP_WIDTH / 2.0, TOP_HEIGHT / 2.0) {
                background :black
              }
            end
          end
        }
      }
    end
  end
end
