# Copyright (c) 2007-2024 Andy Maleh
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

module Rouge
  module Themes
    # A port of the pastie style from Pygments.
    # See https://bitbucket.org/birkenfeld/pygments-main/src/default/pygments/styles/pastie.py
    class GlimmerDark < Github
      name 'glimmer_dark'
      style Comment::Single, fg:      [149, 140, 130], italic: true # Also, Comments
      style Keyword::Pseudo, fg:      [188, 255, 255]
      style Keyword::Declaration, fg:      [188, 255, 255]
      style Keyword, fg:     [153, 38, 16], bold: true
      style Literal::String::Single, fg:      [149, 140, 130] # Also, Comments
      style Literal::String::Double, fg:     [255, 163, 58]
      style Literal::String::Escape, fg:      [6, 217, 141]
      style Literal::Number::Integer, fg:     [153, 38, 16], bold: true
      style Literal::String::Interpol, fg:    [153, 38, 16], bold: true
      style Literal::String::Symbol, fg:      [255, 127, 255]
      style Literal::String, fg:      [163, 215, 252]
      style Name::Builtin, fg:     [40, 197, 182]
      style Name::Class, fg:       [252, 208, 157]
      style Name::Namespace, fg: [252, 208, 157]
      style Name::Constant, fg:    [255, 163, 58]
      style Name::Function, fg:    [153, 38, 16], bold: true
      style Name::Variable::Instance, fg:    [28, 157, 246]
      style Name::Tag, fg:    [247, 250, 136]
      style Name::Attribute, fg:    [255, 127, 127]
      style Name, fg:        [144, 189, 62] #inverse of purple
      style Operator, fg:    [6, 217, 141]
      style Punctuation, fg: [102, 217, 239]
      style Text, fg:        [180, 180, 180]
    end
  end
end
