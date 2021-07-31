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

# Creates a class-based custom shape representing the `bevel` keyword by convention
class Tetris
  module View
    class Bevel
      include Glimmer::UI::CustomShape
      
      options :base_color, :size, :bevel_pixel_size
      option :x, default: 0
      option :y, default: 0
      
      before_body do
        self.bevel_pixel_size = 0.16*size.to_f if bevel_pixel_size.nil?
      end
      
      body {
        rectangle(x, y, size, size) {
          background <= [self, :base_color]
          polygon(0, 0, size, 0, size - bevel_pixel_size, bevel_pixel_size, bevel_pixel_size, bevel_pixel_size) {
            background <= [self, :base_color, on_read: ->(color_value) {
              unless color_value.nil?
                color = color(color_value)
                rgb(color.red + 4*BEVEL_CONSTANT, color.green + 4*BEVEL_CONSTANT, color.blue + 4*BEVEL_CONSTANT)
              end
            }]
          }
          polygon(size, 0, size - bevel_pixel_size, bevel_pixel_size, size - bevel_pixel_size, size - bevel_pixel_size, size, size) {
            background <= [self, :base_color, on_read: ->(color_value) {
              unless color_value.nil?
                color = color(color_value)
                rgb(color.red - BEVEL_CONSTANT, color.green - BEVEL_CONSTANT, color.blue - BEVEL_CONSTANT)
              end
            }]
          }
          polygon(size, size, 0, size, bevel_pixel_size, size - bevel_pixel_size, size - bevel_pixel_size, size - bevel_pixel_size) {
            background <= [self, :base_color, on_read: ->(color_value) {
              unless color_value.nil?
                color = color(color_value)
                rgb(color.red - 2*BEVEL_CONSTANT, color.green - 2*BEVEL_CONSTANT, color.blue - 2*BEVEL_CONSTANT)
              end
            }]
          }
          polygon(0, 0, 0, size, bevel_pixel_size, size - bevel_pixel_size, bevel_pixel_size, bevel_pixel_size) {
            background <= [self, :base_color, on_read: ->(color_value) {
              unless color_value.nil?
                color = color(color_value)
                rgb(color.red - BEVEL_CONSTANT, color.green - BEVEL_CONSTANT, color.blue - BEVEL_CONSTANT)
              end
            }]
          }
          rectangle(0, 0, size, size) {
            foreground <= [self, :base_color, on_read: ->(color_value) {
              # use gray instead of white for the border
              color_value == Model::Block::COLOR_CLEAR ? :gray : color_value
            }]
          }
        }
      }
    end
  end
end
