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
  text 'Hello, Canvas!'
  minimum_size 320, 400

  canvas {
    background :yellow
    rectangle(0, 0, 220, 400, fill: true) {
      background :red
    }
    round_rectangle(50, 20, 300, 150, 30, 50, fill: true) {
      background :magenta
    }
    gradient_rectangle(150, 200, 100, 70, true, fill: true) {
      background :dark_magenta
      foreground :yellow
    }
    gradient_rectangle(50, 200, 30, 70, false, fill: true) {
      background :magenta
      foreground :dark_blue
    }
    rectangle(200, 80, 108, 36) {
      foreground color(:dark_blue)
    }
    text('Picasso', 60, 80) {
      background :yellow
      foreground :dark_magenta
      font name: 'Courier', height: 30
    }
    oval(110, 310, 100, 100, fill: true) {
      background rgb(128, 138, 248)
    }
    arc(210, 210, 100, 100, 30, -77, fill: true) {
      background :red
    }
    polygon([250, 210, 260, 170, 270, 210, 290, 230, 250, 210]) {
      background :dark_yellow
    }
  }
}.open
