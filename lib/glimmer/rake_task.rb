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

module Glimmer
  module RakeTask
    RVM_FUNCTION = <<~MULTI_LINE_STRING
      # Load RVM into a shell session *as a function*
      if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
      
        # First try to load from a user install
        source "$HOME/.rvm/scripts/rvm"
      
      elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then
      
        # Then try to load from a root install
        source "/usr/local/rvm/scripts/rvm"
      
      fi
    MULTI_LINE_STRING
  end
end

require 'rake'
    
require_relative 'rake_task/package'

ENV['GLIMMER_LOGGER_ENABLED'] = 'false'
require_relative '../ext/glimmer/config.rb'

require 'puts_debuggerer' if ("#{ENV['pd']}#{ENV['PD']}").to_s.downcase.include?('true')

namespace :glimmer do
  desc 'Runs Glimmer app or custom shell gem in the current directory, unless app_path is specified, then runs it instead (app_path is optional)'
  task :run, [:app_path] do |t, args|
    require_relative 'launcher'
    if args[:app_path].nil?
      require 'fileutils'
      current_directory_name = File.basename(FileUtils.pwd)
      assumed_shell_script = File.join('.', 'bin', current_directory_name)
      assumed_shell_script = Dir.glob('./bin/*').detect {|f| File.file?(f)} if !File.exist?(assumed_shell_script)
      Glimmer::Launcher.new([assumed_shell_script]).launch
    else
      Glimmer::Launcher.new([args[:app_path]]).launch
    end
  end
  
  desc 'Brings up the Glimmer Meta-Sample app to allow browsing, running, and viewing code of Glimmer samples'
  task :samples do
    Glimmer::Launcher.new([File.expand_path('../../../samples/elaborate/meta_sample.rb', __FILE__)]).launch
  end
  
  namespace :package do
    desc 'Clean by removing "dist" and "packages" directories'
    task :clean do
      Glimmer::RakeTask::Package.clean
    end

    desc 'Generate gemspec'
    task :gemspec do
      Glimmer::RakeTask::Package.gemspec
    end

    desc 'Generate gem under pkg directory'
    task :gem do
      Glimmer::RakeTask::Package.gem
    end

    desc 'Generate JAR config file'
    task :config do
      Glimmer::RakeTask::Package.config
    end

    desc 'Generate JAR file'
    task :jar do
      Glimmer::RakeTask::Package.jar
    end

    desc 'Lock JARs'
    task :lock_jars do
      Glimmer::RakeTask::Package.lock_jars
    end

    desc 'Generate Native files. type can be dmg/pkg on the Mac, msi/exe on Windows, and rpm/deb on Linux (type is optional)'
    task :native, [:type] do |t, args|
      extra_args = ARGV.partition {|arg| arg.include?('package:native')}.last.to_a.join(' ')
      Glimmer::RakeTask::Package.native(args[:type], extra_args)
    end
  end

  desc 'Package app for distribution (generating config, jar, and native files) (type is optional)'
  task :package, [:type] do |t, args|
    Rake::Task['glimmer:package:gemspec'].execute
    Rake::Task['glimmer:package:lock_jars'].execute
    Rake::Task['glimmer:package:config'].execute
    Rake::Task['glimmer:package:jar'].execute
    if OS.linux?
      Rake::Task['glimmer:package:gem'].execute
    else
      Rake::Task['glimmer:package:native'].execute(args)
    end
  end

  desc 'Webifies an existing Glimmer desktop app by generating a Glimmer DSL for Opal Rails server'
  task :webify do
    require_relative 'rake_task/scaffold'
    Glimmer::RakeTask::Scaffold.webify
  end

  desc 'Scaffold Glimmer application directory structure to build a new app'
  task :scaffold, [:app_name] do |t, args|
    require_relative 'rake_task/scaffold'
    Glimmer::RakeTask::Scaffold.app(args[:app_name])
  end

  namespace :scaffold do
    desc 'Scaffold a Web-Ready Glimmer application directory structure including a Glimmer DSL for Opal Rails server'
    task :webready, [:app_name] do |t, args|
      require_relative 'rake_task/scaffold'
      Glimmer::RakeTask::Scaffold.app(args[:app_name], nil, {}, true)
      Glimmer::RakeTask::Scaffold.webify
    end
  
    desc 'Scaffold Glimmer::UI::CustomShell subclass (full window view) under app/views (namespace is optional) [alt: scaffold:cs]'
    task :customshell, [:name, :namespace] do |t, args|
      require_relative 'rake_task/scaffold'
      Glimmer::RakeTask::Scaffold.custom_shell(args[:name], args[:namespace])
    end
    
    task :cs, [:name, :namespace] => :customshell
    task :custom_shell, [:name, :namespace] => :customshell
    task :"custom-shell", [:name, :namespace] => :customshell
    
    desc 'Scaffold Glimmer::UI::CustomWidget subclass (part of a view) under app/views (namespace is optional) [alt: scaffold:cw]'
    task :customwidget, [:name, :namespace] do |t, args|
      require_relative 'rake_task/scaffold'
      Glimmer::RakeTask::Scaffold.custom_widget(args[:name], args[:namespace])
    end
    
    task :cw, [:name, :namespace] => :customwidget
    task :custom_widget, [:name, :namespace] => :customwidget
    task :"custom-widget", [:name, :namespace] => :customwidget
    
    desc 'Desktopify a web app'
    task :desktopify, [:app_name, :website] do |t, args|
      require_relative 'rake_task/scaffold'
      Glimmer::RakeTask::Scaffold.desktopify(args[:app_name], args[:website])
    end
    
    namespace :gem do
      desc 'Scaffold Glimmer::UI::CustomShell subclass (full window view) under its own Ruby gem + app project (namespace is required) [alt: scaffold:gem:cs]'
      task :customshell, [:name, :namespace] do |t, args|
        require_relative 'rake_task/scaffold'
        Glimmer::RakeTask::Scaffold.custom_shell_gem(args[:name], args[:namespace])
      end
      
      task :cs, [:name, :namespace] => :customshell
      task :custom_shell, [:name, :namespace] => :customshell
      task :"custom-shell", [:name, :namespace] => :customshell
      
      desc 'Scaffold Glimmer::UI::CustomWidget subclass (part of a view) under its own Ruby gem project (namespace is required) [alt: scaffold:gem:cw]'
      task :customwidget, [:name, :namespace] do |t, args|
        require_relative 'rake_task/scaffold'
        Glimmer::RakeTask::Scaffold.custom_widget_gem(args[:name], args[:namespace])
      end
    
      task :cw, [:name, :namespace] => :customwidget
      task :custom_widget, [:name, :namespace] => :customwidget
      task :"custom-widget", [:name, :namespace] => :customwidget
    end
    
    # legacy support
    
    task :custom_shell_gem, [:name, :namespace] => 'gem:customshell'
    task :custom_widget_gem, [:name, :namespace] => 'gem:customwidget'
    
  end
  
  namespace :list do
    task :list_require do
      require_relative 'rake_task/list'
    end
    
    namespace :gems do
      desc 'List Glimmer custom widget gems available at rubygems.org (query is optional) [alt: list:gems:cw]'
      task :customwidget, [:query] => :list_require do |t, args|
        Glimmer::RakeTask::List.custom_widget_gems(args[:query])
      end
      
      task :cw, [:query] => :customwidget
      task :custom_widget, [:query] => :customwidget
      task :"custom-widget", [:query] => :customwidget
      
      desc 'List Glimmer custom shell gems available at rubygems.org (query is optional) [alt: list:gems:cs]'
      task :customshell, [:query] => :list_require do |t, args|
        Glimmer::RakeTask::List.custom_shell_gems(args[:query])
      end
      
      task :cs, [:query] => :customshell
      task :custom_shell, [:query] => :customshell
      task :"custom-shell", [:query] => :customshell
      
      desc 'List Glimmer DSL gems available at rubygems.org (query is optional)'
      task :dsl, [:query] => :list_require do |t, args|
        Glimmer::RakeTask::List.dsl_gems(args[:query])
      end
    
    end
    
    # legacy support
    
    task :custom_shell_gems, [:name, :namespace] => 'gems:customshell'
    task :custom_widget_gems, [:name, :namespace] => 'gems:customwidget'
    
  end
end
