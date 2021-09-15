require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'os'
require_relative 'lib/glimmer/launcher'
require 'rake'
begin
  juwelier_required = require 'juwelier'
rescue Exception
  juwelier_required = nil
end
unless juwelier_required.nil?
  Juwelier::Tasks.new do |gem|
    # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
    gem.name = "glimmer-dsl-swt"
    gem.homepage = "http://github.com/AndyObtiva/glimmer-dsl-swt"
    gem.license = "MIT"
    gem.summary = %Q{Glimmer DSL for SWT (JRuby Desktop Development GUI Framework)}
    gem.description = %Q{Glimmer DSL for SWT (JRuby Desktop Development GUI Framework) is a native-GUI cross-platform desktop development library written in JRuby, an OS-threaded faster JVM version of Ruby. Glimmer's main innovation is a declarative Ruby DSL that enables productive and efficient authoring of desktop application user-interfaces by relying on the robust Eclipse SWT library. Glimmer additionally innovates by having built-in data-binding support, which greatly facilitates synchronizing the GUI with domain models, thus achieving true decoupling of object oriented components and enabling developers to solve business problems (test-first) without worrying about GUI concerns, or alternatively drive development GUI-first, and then write clean business models (test-first) afterwards. Not only does Glimmer provide a large set of GUI widgets, but it also supports drawing Canvas Graphics like Shapes and Animations. To get started quickly, Glimmer offers scaffolding options for Apps, Gems, and Custom Widgets. Glimmer also includes native-executable packaging support, sorely lacking in other libraries, thus enabling the delivery of desktop apps written in Ruby as truly native DMG/PKG/APP files on the Mac, MSI/EXE files on Windows, and Gem Packaged Shell Scripts on Linux. Glimmer was the first Ruby gem to bring SWT (Standard Widget Toolkit) to Ruby, thanks to creator Andy Maleh, EclipseCon/EclipseWorld/RubyConf speaker and expert.}
    gem.email = "andy.am@gmail.com"
    gem.authors = ["Andy Maleh"]
    gem.post_install_message = ["\nYou are ready to use `glimmer` and `girb` commands on Windows and Linux.\n\nOn the Mac, run `glimmer-setup` command to complete setup of Glimmer DSL for SWT, making `glimmer` and `girb` commands ready for use:\n\nglimmer-setup\n\n"]
    gem.executables = ['glimmer', 'girb', 'glimmer-setup']
    gem.files = Dir['README.md', 'LICENSE.txt', 'RUBY_VERSION', 'VERSION', 'CHANGELOG.md', 'glimmer-dsl-swt.gemspec', 'bin/**/*', 'docs/**/*', 'lib/**/*', 'vendor/**/*', 'icons/**/*', 'samples/**/*', 'sounds/**/*']
    gem.require_paths = ['lib', 'bin']
    gem.extra_rdoc_files = Dir['README.md', 'docs/**/*']
    gem.required_ruby_version = ">= 2.5.3"
    # dependencies defined in Gemfile
  end
  Juwelier::RubygemsDotOrgTasks.new
end

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
  # spec.ruby_opts = ["-Xcli.debug=true --debug #{Glimmer::Launcher.jruby_os_specific_options}"]
  # NOTE: Disabled debug flags because they were giving noisy output on raise of an error

  # spec.ruby_opts = ["--profile.graph #{Glimmer::Launcher.jruby_os_specific_options}"]
  # require 'jruby/profiler'
  # profile_data = JRuby::Profiler.profile do
  # end

  spec.ruby_opts = [Glimmer::Launcher.jruby_os_specific_options]
end

task :default => :spec

task :no_puts_debuggerer do
  ENV['puts_debuggerer'] = 'false'
end

namespace :build do
  desc 'Builds without running specs for quick testing, but not release'
  task :prototype => :no_puts_debuggerer do
    Rake::Task['build'].execute
  end
end

Rake::Task["build"].enhance [:no_puts_debuggerer, :spec] unless OS.windows? && ARGV.include?('release')
