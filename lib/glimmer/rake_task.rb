require 'rake'

require_relative 'package'

namespace :glimmer do
  namespace :package do
    desc 'Generate JAR config file'
    task :config do
      Glimmer::Package.config
    end

    desc 'Generate JAR file'
    task :jar do
      Glimmer::Package.jar
    end

    desc 'Generate Native files (DMG/PKG/APP on the Mac, EXE on Windows, RPM/DEB on Linux)'
    task :native do
      Glimmer::Package.native
    end
  end

  desc 'Package app for distribution (generating config, jar, and native files)'
  task :package do
    Rake::Task['glimmer:package:config'].execute
    Rake::Task['glimmer:package:jar'].execute
    Rake::Task['glimmer:package:native'].execute
  end


  desc 'Scaffold a Glimmer application directory structure to begin building a new app'
  task :scaffold, [:app_name] do |t, args|
    require_relative 'scaffold'
    Scaffold.app(args[:app_name])
  end

  namespace :scaffold do
    desc 'Scaffold a Glimmer::UI::CustomShell subclass (represents a full window view) under app/views (namespace is optional)'
    task :custom_shell, [:custom_shell_name, :namespace] do |t, args|
      require_relative 'scaffold'
      Scaffold.custom_shell(args[:custom_shell_name], args[:namespace])
    end
    
    desc 'Scaffold a Glimmer::UI::CustomWidget subclass (represents a part of a view) under app/views (namespace is optional)'
    task :custom_widget, [:custom_widget_name, :namespace] do |t, args|
      require_relative 'scaffold'
      Scaffold.custom_widget(args[:custom_widget_name], args[:namespace])
    end
    
    desc 'Scaffold a Glimmer::UI::CustomShell subclass (represents a full window view) under its own Ruby gem + app project (namespace is required)'
    task :custom_shell_gem, [:custom_shell_name, :namespace] do |t, args|
      require_relative 'scaffold'
      Scaffold.custom_shell_gem(args[:custom_shell_name], args[:namespace])
    end
    
    desc 'Scaffold a Glimmer::UI::CustomWidget subclass (represents a part of a view) under its own Ruby gem project (namespace is required)'
    task :custom_widget_gem, [:custom_widget_name, :namespace] do |t, args|
      require_relative 'scaffold'
      Scaffold.custom_widget_gem(args[:custom_widget_name], args[:namespace])
    end
  end
  
  namespace :list do
    task :list_require do
      require_relative 'rake_task/list'
    end
  
    desc 'List Glimmer custom widget gems available at rubygems.org'
    task :custom_widget_gems => :list_require do
      Glimmer::RakeTask::List.custom_widget_gems
    end
    
    desc 'List Glimmer custom shell gems available at rubygems.org'
    task :custom_shell_gems => :list_require do
      Glimmer::RakeTask::List.custom_shell_gems
    end
    
    desc 'List Glimmer DSL gems available at rubygems.org'
    task :dsl_gems => :list_require do
      Glimmer::RakeTask::List.dsl_gems
    end
    
  end
end
