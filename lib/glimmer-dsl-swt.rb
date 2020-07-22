$LOAD_PATH.unshift(File.expand_path('..', __FILE__))

# External requires
require 'java'
if ENV['BUNDLER_REQUIRE'].to_s.downcase == 'true'
  require 'bundler'
  Bundler.require
else
  require 'glimmer'
  require 'logging'
  require 'nested_inherited_jruby_include_package'
  require 'super_module'
end

# Internal requires
require 'ext/glimmer/config'
require 'ext/glimmer'
require 'glimmer/dsl/swt/dsl'
