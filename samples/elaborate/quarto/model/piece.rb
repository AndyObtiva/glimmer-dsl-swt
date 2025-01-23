# Copyright (c) 2007-2025 Andy Maleh
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
  module Model
    class Piece
      class << self
        def all_pieces
          [
            Cube.new(pitted: false, height: :tall, color: :light),
            Cylinder.new(pitted: false, height: :tall, color: :light),
            Cube.new(pitted: true, height: :short, color: :light),
            Cube.new(pitted: false, height: :short, color: :light),
            Cube.new(pitted: false, height: :tall, color: :dark),
            Cylinder.new(pitted: true, height: :short, color: :dark),
            Cylinder.new(pitted: false, height: :short, color: :dark),
            Cylinder.new(pitted: true, height: :tall, color: :dark),
            Cylinder.new(pitted: false, height: :tall, color: :dark),
            Cube.new(pitted: true, height: :short, color: :dark),
            Cube.new(pitted: false, height: :short, color: :dark),
            Cube.new(pitted: true, height: :tall, color: :dark),
          ].freeze
        end
      end
      
      attr_reader :pitted, :height, :color
      alias pitted? pitted
      
      def initialize(pitted: , height: , color: )
        @pitted = pitted
        @height = height
        @color = color
      end
      
      def light?
        @color == :light
      end
      
      def dark?
        @color == :dark
      end
      
      def tall?
        @height == :tall
      end
      
      def short?
        @height == :short
      end
    end
  end
end
