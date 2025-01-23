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

$LOAD_PATH.unshift(File.expand_path('..', __FILE__))

# External requires
if !['', 'false'].include?(ENV['GLIMMER_BUNDLER_SETUP'].to_s.strip.downcase)
  bundler_group = ENV['GLIMMER_BUNDLER_SETUP'].to_s.strip.downcase
  bundler_group = 'default' if bundler_group == 'true'
  require 'bundler'
  Bundler.setup(bundler_group)
end
require 'java'
require 'puts_debuggerer' if ("#{ENV['pd']}#{ENV['PD']}").to_s.downcase.include?('true')

# concurrent-ruby gem ensures glimmer relies on Concurrent data-structure classes
require 'concurrent/array'
require 'concurrent/hash'
require 'concurrent/set'
require 'glimmer'

require 'nested_inherited_jruby_include_package'
require 'super_module'
require 'date'
require 'facets/string/capitalized'
require 'facets/hash/symbolize_keys'
require 'matrix'

# Internal requires
require 'ext/glimmer/config'
require 'ext/glimmer'
require 'glimmer/dsl/swt/dsl'

if defined?(::IRB)
  begin
    Kernel.send(:remove_method, :y)
  rescue
    # No Op
  end
end
