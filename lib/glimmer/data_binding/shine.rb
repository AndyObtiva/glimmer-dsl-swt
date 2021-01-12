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

## NOTE: Unsupported for now TODO support in the future
#
# require File.dirname(__FILE__) + "/glimmer"
#
# class Array
#   include Glimmer
#
#   alias original_compare <=>
#
#   def <=>(other)
#     if (self[0].class.name == "WidgetProxy")
#       content(self[0]) {
#         if (other.size == 2)
#           eval("#{self[1]} bind (other[0], other[1])")
#         elsif (other.size == 3)
#           eval("#{self[1]} bind (other[0], other[1], other[2])")
#         end
#       }
#     else
#       original_compare(other)
#     end
#   end
# end
