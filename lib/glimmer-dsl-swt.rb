$LOAD_PATH.unshift(File.expand_path('..', __FILE__))

# External requires
require 'java'
require 'puts_debuggerer' if ("#{ENV['pd']}#{ENV['PD']}").to_s.downcase.include?('true')
require 'glimmer'
require 'logging'
require 'nested_inherited_jruby_include_package'
require 'super_module'

# Internal requires
require 'ext/glimmer/config'
require 'ext/glimmer'
require 'glimmer/dsl/swt/dsl'
