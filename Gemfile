source 'http://rubygems.org'

ruby '>= 2.5.3', :engine => 'jruby', engine_version: '>= 9.2.6.0'

# Glimmer project owner gems
gem 'glimmer', '~> 1.0.0' #, path: '../glimmer'
gem 'super_module', '~> 1.4.1'
gem 'nested_inherited_jruby_include_package', '~> 0.3.0'
gem 'puts_debuggerer', '~> 0.10.1', require: false
gem 'rake-tui', '>= 0.2.2', '< 2.0.0'

# Temporary until merged into base gem
gem 'git-glimmer', '1.7.0'

# 3rd party gems (flexible versions to support other user gems that may share dependencies)
gem 'juwelier', '>= 2.4.9', '< 3.0.0'
gem 'logging', '>= 2.3.0', '< 3.0.0'
gem 'os', '>= 1.0.0', '< 2.0.0'
gem 'rake', '>= 10.1.0', '< 14.0.0'
gem 'rdoc', '>= 6.2.1', '< 7.0.0'
gem 'text-table', '>= 1.2.4', '< 2.0.0'
gem 'tty-markdown', '>= 0.6.0', '< 2.0.0'
gem 'warbler', '>= 2.0.5', '< 3.0.0'

group :development do
  gem "rspec-mocks", "~> 3.5.0"
  gem "rspec", "~> 3.5.0"
  gem 'coveralls', '= 0.8.23', require: false
  gem 'simplecov', '~> 0.16.1', require: nil
  gem 'simplecov-lcov', '~> 0.7.0', require: nil
end
