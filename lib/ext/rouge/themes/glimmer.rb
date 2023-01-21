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

module Rouge
  module Themes
    # A port of the pastie style from Pygments.
    # See https://bitbucket.org/birkenfeld/pygments-main/src/default/pygments/styles/pastie.py
    class Glimmer < Github
      name 'glimmer'
      style Comment::Single, fg:      [106,115,125], italic: true # Also, Comments
      style Keyword::Pseudo, fg:      [:dark_red]
      style Keyword, fg:     [:blue]
      style Literal::String::Single, fg:      [106,115,125] # Also, Comments
      style Literal::String::Double, fg:     [0,92,197]
      style Literal::String::Escape, fg:      [:red]
      style Literal::Number::Integer, fg:     [:blue]
      style Literal::String::Interpol, fg:    [:blue]
      style Literal::String::Symbol, fg:      [:dark_green]
      style Literal::String, fg:      [:dark_blue]
      style Name::Builtin, fg:     [215,58,73]
      style Name::Class, fg:       [3,47,98]
      style Name::Namespace, fg: [3,47,98]
      style Name::Constant, fg:    [0,92,197]
      style Name::Function, fg:    [:blue]
      style Name::Variable::Instance, fg:    [227,98,9]
      style Name, fg:        [111,66,193] #purple
      style Operator, fg:    [:red]
      style Punctuation, fg: [:blue]
      style Text, fg:        [75, 75, 75]
    end
  end
end
