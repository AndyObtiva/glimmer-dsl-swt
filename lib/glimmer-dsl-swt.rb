$LOAD_PATH.unshift(File.expand_path('..', __FILE__))

# External requires
require 'java'
require 'nested_inherited_jruby_include_package'
require 'super_module'
require 'glimmer'

# Internal requires
require 'ext/glimmer/config'
require 'ext/glimmer'
require 'glimmer/dsl/swt/dsl'
