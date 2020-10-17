# Copyright (c) 2007-2020 Andy Maleh
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

require 'fileutils'
require 'os'
require 'facets'

# TODO refactor to nest under RakeTask namespace

MAIN_OBJECT = self

module Glimmer
  module RakeTask
    class Scaffold
      class << self
        include FileUtils
    
        VERSION = File.read(File.expand_path('../../../../VERSION', __FILE__)).strip
        RUBY_VERSION = File.read(File.expand_path('../../../../RUBY_VERSION', __FILE__)).strip
    
        # TODO externalize all constants into scaffold/files
    
        GITIGNORE = <<~MULTI_LINE_STRING
          *.gem
          *.rbc
          /.config
          /coverage/
          /InstalledFiles
          /pkg/
          /spec/reports/
          /spec/examples.txt
          /test/tmp/
          /test/version_tmp/
          /tmp/
          
          # Used by dotenv library to load environment variables.
          # .env
          
          ## Specific to RubyMotion:
          .dat*
          .repl_history
          build/
          *.bridgesupport
          build-iPhoneOS/
          build-iPhoneSimulator/
          
          ## Specific to RubyMotion (use of CocoaPods):
          #
          # We recommend against adding the Pods directory to your .gitignore. However
          # you should judge for yourself, the pros and cons are mentioned at:
          # https://guides.cocoapods.org/using/using-cocoapods.html#should-i-check-the-pods-directory-into-source-control
          #
          # vendor/Pods/
          
          ## Documentation cache and generated files:
          /.yardoc/
          /_yardoc/
          /doc/
          /rdoc/
          
          ## Environment normalization:
          /.bundle/
          /vendor/bundle
          /lib/bundler/man/
          
          # for a library or gem, you might want to ignore these files since the code is
          # intended to run in multiple environments; otherwise, check them in:
          # Gemfile.lock
          # .ruby-version
          # .ruby-gemset
          
          # unless supporting rvm < 1.11.0 or doing something fancy, ignore this:
          .rvmrc
          
          # Mac
          .DS_Store
          
          # Gladiator (Glimmer Editor)
          .gladiator
          
          # Glimmer
          dist
          packages
          vendor/jars
        MULTI_LINE_STRING
    
        GEMFILE = <<~MULTI_LINE_STRING
          # frozen_string_literal: true
          
          source 'https://rubygems.org'
          
          git_source(:github) {|repo_name| "https://github.com/\#{repo_name}" }
          
          gem 'glimmer-dsl-swt', '~> #{VERSION}'
          
          group :development do
            gem 'rspec', '~> 3.5.0'
            gem 'git-glimmer', '1.7.0'
            gem 'juwelier', '2.4.9'
            gem 'warbler', '2.0.5'
            gem 'simplecov', '>= 0'
          end
        MULTI_LINE_STRING
    
        def app(app_name)
          common_app(app_name) do
            custom_shell('AppView', current_dir_name, :app)          
          end
        end
        
        def desktopify(app_name, website)
          common_app(app_name) do
            custom_shell('AppView', current_dir_name, :desktopify, website: website)
          end
        end
        
        def common_app(app_name, &view_scaffolding_block)
          gem_name = file_name(app_name)
          gem_summary = human_name(app_name)
          return puts("The directory '#{gem_name}' already exists. Please either remove or pick a different name.") if Dir.exist?(gem_name)
          system "jruby -S gem install juwelier -v2.4.9 --no-document" unless juwelier_exists?
          system "jruby -r git-glimmer -S juwelier --markdown --rspec --summary '#{gem_summary}' --description '#{gem_summary}' #{gem_name}" 
          return puts('Your Git user.name and/or github.user are missing! Please add in for Juwelier to help Glimmer with Scaffolding.') if `git config --get github.user`.strip.empty? && `git config --get user.name`.strip.empty?
          cd gem_name
          rm_rf 'lib'
          write '.gitignore', GITIGNORE
          write '.ruby-version', RUBY_VERSION        
          write '.ruby-gemset', app_name
          write 'VERSION', '1.0.0'
          write 'LICENSE.txt', "Copyright (c) #{Time.now.year} #{app_name}"
          write 'Gemfile', GEMFILE
          write 'Rakefile', gem_rakefile(app_name, nil, gem_name)
          mkdir 'app'
          write "app/#{file_name(app_name)}.rb", app_main_file(app_name)
          mkdir 'app/models'
          mkdir 'app/views'
          view_scaffolding_block.call          
            
          mkdir_p 'package/windows'
          icon_file = "package/windows/#{human_name(app_name)}.ico"
          cp File.expand_path('../../../../icons/scaffold_app.ico', __FILE__), icon_file
          puts "Created #{current_dir_name}/#{icon_file}"
          
          mkdir_p 'package/macosx'
          icon_file = "package/macosx/#{human_name(app_name)}.icns"
          cp File.expand_path('../../../../icons/scaffold_app.icns', __FILE__), icon_file
          puts "Created #{current_dir_name}/#{icon_file}"
        
          mkdir_p 'package/linux'
          icon_file = "package/linux/#{human_name(app_name)}.png"
          cp File.expand_path('../../../../icons/scaffold_app.png', __FILE__), icon_file
          puts "Created #{current_dir_name}/#{icon_file}"
        
          mkdir 'bin'
          write "bin/#{file_name(app_name)}", app_bin_file(app_name)
          if OS.windows?
            system "bundle"
            system "rspec --init"
          else
            system "bash -c '#{RVM_FUNCTION}\n cd .\n bundle\n rspec --init\n'"
          end      
          write 'spec/spec_helper.rb', spec_helper_file
          if OS.windows?
            system "glimmer package[image]"
            system "\"packages/bundles/#{human_name(app_name)}/#{human_name(app_name)}.exe\""
          else
            system "bash -c '#{RVM_FUNCTION}\n cd .\n glimmer package\n'"
            if OS.mac?
              system "open packages/bundles/#{human_name(app_name).gsub(' ', '\ ')}.app"
            else
              system "glimmer bin/#{file_name(app_name)}"
            end
          end        
        end
    
        def custom_shell(custom_shell_name, namespace, shell_type = nil, shell_options = {})
          namespace ||= current_dir_name
          root_dir = File.exists?('app') ? 'app' : 'lib'
          parent_dir = "#{root_dir}/views/#{file_name(namespace)}"
          return puts("The file '#{parent_dir}/#{file_name(custom_shell_name)}.rb' already exists. Please either remove or pick a different name.") if File.exist?("#{parent_dir}/#{file_name(custom_shell_name)}.rb")
          mkdir_p parent_dir unless File.exists?(parent_dir)
          write "#{parent_dir}/#{file_name(custom_shell_name)}.rb", custom_shell_file(custom_shell_name, namespace, shell_type, shell_options)
        end
    
        def custom_widget(custom_widget_name, namespace)
          namespace ||= current_dir_name
          root_dir = File.exists?('app') ? 'app' : 'lib'
          parent_dir = "#{root_dir}/views/#{file_name(namespace)}"
          return puts("The file '#{parent_dir}/#{file_name(custom_widget_name)}.rb' already exists. Please either remove or pick a different name.") if File.exist?("#{parent_dir}/#{file_name(custom_widget_name)}.rb")
          mkdir_p parent_dir unless File.exists?(parent_dir)
          write "#{parent_dir}/#{file_name(custom_widget_name)}.rb", custom_widget_file(custom_widget_name, namespace)
        end
    
        def custom_shell_gem(custom_shell_name, namespace)
          gem_name = "glimmer-cs-#{compact_name(custom_shell_name)}"
          gem_summary = "#{human_name(custom_shell_name)} - Glimmer Custom Shell"
          begin
            custom_shell_keyword = dsl_widget_name(custom_shell_name)
            MAIN_OBJECT.method(custom_shell_keyword)
            return puts("CustomShell keyword `#{custom_shell_keyword}` is unavailable (occupied by a built-in Ruby method)! Please pick a different name.")
          rescue NameError
            # No Op (keyword is not taken by a built in Ruby method)
          end
          if namespace
            gem_name += "-#{compact_name(namespace)}"
            gem_summary += " (#{human_name(namespace)})"
          else
            return puts('Namespace is required! Usage: glimmer scaffold:gem:customshell[name,namespace]') unless `git config --get github.user`.to_s.strip == 'AndyObtiva'
            namespace = 'glimmer'
          end
          return puts("The directory '#{gem_name}' already exists. Please either remove or pick a different name.") if Dir.exist?(gem_name)
          system "jruby -S gem install juwelier -v2.4.9 --no-document" unless juwelier_exists?
          system "jruby -r git-glimmer -S juwelier --markdown --rspec --summary '#{gem_summary}' --description '#{gem_summary}' #{gem_name}" 
          return puts('Your Git user.name and/or github.user are missing! Please add in for Juwelier to help Glimmer with Scaffolding.') if `git config --get github.user`.strip.empty? && `git config --get user.name`.strip.empty?
          cd gem_name
          write '.gitignore', GITIGNORE
          write '.ruby-version', RUBY_VERSION        
          write '.ruby-gemset', gem_name
          write 'VERSION', '1.0.0'
          write 'Gemfile', GEMFILE
          write 'Rakefile', gem_rakefile(custom_shell_name, namespace, gem_name)
          append "lib/#{gem_name}.rb", gem_main_file(custom_shell_name, namespace)
          mkdir 'lib/views'
          custom_shell(custom_shell_name, namespace, :gem)
          mkdir 'bin'
          write "bin/#{gem_name}", gem_bin_file(gem_name, custom_shell_name, namespace)
          write "bin/#{file_name(custom_shell_name)}", gem_bin_command_file(gem_name)
          FileUtils.chmod 0755, "bin/#{file_name(custom_shell_name)}"
          if OS.windows?
            system "bundle"
            system "rspec --init"
          else
            system "bash -c '#{RVM_FUNCTION}\n cd .\n bundle\n rspec --init\n'"
          end      
          write 'spec/spec_helper.rb', spec_helper_file
    
          mkdir_p 'package/windows'
          icon_file = "package/windows/#{human_name(custom_shell_name)}.ico"
          cp File.expand_path('../../../../icons/scaffold_app.ico', __FILE__), icon_file
          puts "Created #{current_dir_name}/#{icon_file}"
            
          mkdir_p 'package/macosx'
          icon_file = "package/macosx/#{human_name(custom_shell_name)}.icns"
          cp File.expand_path('../../../../icons/scaffold_app.icns', __FILE__), icon_file
          puts "Created #{current_dir_name}/#{icon_file}"
          
          mkdir_p 'package/linux'
          icon_file = "package/linux/#{human_name(custom_shell_name)}.png"
          cp File.expand_path('../../../../icons/scaffold_app.png', __FILE__), icon_file
          puts "Created #{current_dir_name}/#{icon_file}"
          
          if OS.windows?
            system "glimmer package[image]"
            system "\"packages/bundles/#{human_name(custom_shell_name)}/#{human_name(custom_shell_name)}.exe\""
          else
            system "bash -c '#{RVM_FUNCTION}\n cd .\n glimmer package\n'"
            if OS.mac?
              system "open packages/bundles/#{human_name(custom_shell_name).gsub(' ', '\ ')}.app" if OS.mac?
            else
              system "bin/#{file_name(custom_shell_name)}"
            end        
          end
          puts "Finished creating #{gem_name} Ruby gem."
          puts 'Edit Rakefile to configure gem details.'
          puts 'Run `rake` to execute specs.'
          puts 'Run `rake build` to build gem.'
          puts 'Run `rake release` to release into rubygems.org once ready.'
        end
    
        def custom_widget_gem(custom_widget_name, namespace)
          return puts('Namespace is required! Usage: glimmer scaffold:custom_widget_gem[custom_widget_name,namespace]') unless `git config --get github.user`.to_s.strip == 'AndyObtiva'
          gem_name = "glimmer-cw-#{compact_name(custom_widget_name)}"
          gem_summary = "#{human_name(custom_widget_name)} - Glimmer Custom Widget"
          if namespace
            gem_name += "-#{compact_name(namespace)}"
            gem_summary += " (#{human_name(namespace)})"
          else
            namespace = 'glimmer'
          end
          
          return puts("The directory '#{gem_name}' already exists. Please either remove or pick a different name.") if Dir.exist?(gem_name)
          system "jruby -S gem install juwelier -v2.4.9 --no-document" unless juwelier_exists?
          system "jruby -r git-glimmer -S juwelier --markdown --rspec --summary '#{gem_summary}' --description '#{gem_summary}' #{gem_name}" 
          return puts('Your Git user.name and/or github.user are missing! Please add in for Juwelier to help Glimmer with Scaffolding.') if `git config --get github.user`.strip.empty? && `git config --get user.name`.strip.empty?
          cd gem_name
          write '.gitignore', GITIGNORE
          write '.ruby-version', RUBY_VERSION        
          write '.ruby-gemset', gem_name
          write 'VERSION', '1.0.0'
          write 'Gemfile', GEMFILE
          write 'Rakefile', gem_rakefile
          append "lib/#{gem_name}.rb", gem_main_file(custom_widget_name, namespace)
          mkdir 'lib/views'
          custom_widget(custom_widget_name, namespace)
          if OS.windows?
            system "bundle"
            system "rspec --init"
          else
            system "bash -c '#{RVM_FUNCTION}\n cd .\n bundle\n rspec --init\n'"
          end
          write 'spec/spec_helper.rb', spec_helper_file
          puts "Finished creating #{gem_name} Ruby gem."
          puts 'Edit Rakefile to configure gem details.'
          puts 'Run `rake` to execute specs.'
          puts 'Run `rake build` to build gem.'
          puts 'Run `rake release` to release into rubygems.org once ready.'
        end
    
        private
        
        def juwelier_exists?
          OS.windows? ? system('where juwelier') : system('which juwelier')
        end
    
        def write(file, content)
          File.write file, content
          file_path = File.expand_path(file)
          puts "Created #{current_dir_name}/#{file}"
        end
    
        def append(file, content)
          File.open(file, 'a') do |f|
            f.write(content)
          end
        end
    
        def current_dir_name
          File.basename(File.expand_path('.'))
        end
    
        def class_name(app_name)
          app_name.underscore.camelcase(:upper)
        end
    
        def file_name(app_name)
          app_name.underscore
        end
        alias dsl_widget_name file_name
    
        def human_name(app_name)
          app_name.underscore.titlecase
        end
    
        def compact_name(gem_name)
          gem_name.underscore.camelcase.downcase
        end
    
        def app_main_file(app_name)
          <<~MULTI_LINE_STRING
            $LOAD_PATH.unshift(File.expand_path('..', __FILE__))
    
            require 'bundler/setup'
            Bundler.require(:default)
            require 'views/#{file_name(app_name)}/app_view'
    
            class #{class_name(app_name)}
              include Glimmer
            
              APP_ROOT = File.expand_path('../..', __FILE__)        
              VERSION = File.read(File.join(APP_ROOT, 'VERSION'))
              LICENSE = File.read(File.join(APP_ROOT, 'LICENSE.txt'))          
                        
              def open
                app_view.open
              end
            end
          MULTI_LINE_STRING
        end
    
        def gem_main_file(custom_widget_name, namespace = nil)
          custom_widget_file_path = "views"
          custom_widget_file_path += "/#{file_name(namespace)}" if namespace
          custom_widget_file_path += "/#{file_name(custom_widget_name)}"
    
          <<~MULTI_LINE_STRING
            $LOAD_PATH.unshift(File.expand_path('..', __FILE__))
            
            require 'glimmer-dsl-swt'
            require '#{custom_widget_file_path}'
          MULTI_LINE_STRING
        end
    
        def app_bin_file(app_name)
          <<~MULTI_LINE_STRING
            require_relative '../app/#{file_name(app_name)}'
            
            #{class_name(app_name)}.new.open
          MULTI_LINE_STRING
        end
    
        def gem_bin_file(gem_name, custom_shell_name, namespace)
          # TODO change this so that it does not mix Glimmer unto the main object
          <<~MULTI_LINE_STRING
            require_relative '../lib/#{gem_name}'
            
            class #{class_name(custom_shell_name)}App
              include Glimmer
            
              def open
                #{dsl_widget_name(custom_shell_name)}.open
              end
            end
            
            #{class_name(custom_shell_name)}App.new.open
          MULTI_LINE_STRING
        end
    
        def gem_bin_command_file(gem_name)
          <<~MULTI_LINE_STRING
            #!/usr/bin/env jruby
            
            require 'glimmer/launcher'
            
            runner = File.expand_path("../#{gem_name}", __FILE__)
            launcher = Glimmer::Launcher.new([runner] + ARGV)
            launcher.launch
          MULTI_LINE_STRING
        end
    
        def gem_rakefile(custom_shell_name = nil, namespace = nil, gem_name = nil)
          rakefile_content = File.read('Rakefile')
          lines = rakefile_content.split("\n")
          require_rake_line_index = lines.index(lines.detect {|l| l.include?("require 'rake'") })
          lines.insert(require_rake_line_index, "require 'glimmer/launcher'")
          gem_files_line_index = lines.index(lines.detect {|l| l.include?('# dependencies defined in Gemfile') })
          if custom_shell_name
            lines.insert(gem_files_line_index, "  gem.files = Dir['VERSION', 'LICENSE.txt', 'lib/**/*', 'app/**/*', 'bin/**/*', 'vendor/**/*', 'package/**/*']")
            lines.insert(gem_files_line_index+1, "  gem.executables = ['#{gem_name}', '#{file_name(custom_shell_name)}']")
            lines.insert(gem_files_line_index+2, "  gem.require_paths = ['vendor', 'lib', 'app']")
          else
            lines.insert(gem_files_line_index, "  gem.files = Dir['VERSION', 'LICENSE.txt', 'lib/**/*']")
          end
          spec_pattern_line_index = lines.index(lines.detect {|l| l.include?('spec.pattern =') })
          lines.insert(spec_pattern_line_index+1, "  spec.ruby_opts = [Glimmer::Launcher.jruby_os_specific_options]")
          lines << "\nrequire 'glimmer/rake_task'\n"       
          file_content = lines.join("\n")
          if custom_shell_name
            file_content << <<~MULTI_LINE_STRING  
              Glimmer::RakeTask::Package.javapackager_extra_args =
                " -name '#{human_name(custom_shell_name)}'" +
                " -title '#{human_name(custom_shell_name)}'" +
                " -Bmac.CFBundleName='#{human_name(custom_shell_name)}'" +
                " -Bmac.CFBundleIdentifier='org.#{namespace ? compact_name(namespace) : compact_name(custom_shell_name)}.application.#{compact_name(custom_shell_name).camelcase(:upper)}'" 
                # " -BlicenseType=" +
                # " -Bmac.category=" +
                # " -Bmac.signing-key-developer-id-app="
            MULTI_LINE_STRING
          end
          file_content
        end
    
        def spec_helper_file
          content = File.read('spec/spec_helper.rb')
          lines = content.split("\n")
          require_line_index = lines.index(lines.detect {|l| l.include?('RSpec.configure do') })
          lines[require_line_index...require_line_index] = [
            "require 'bundler/setup'",
            'Bundler.require(:default, :development)',
          ]
          configure_block_line_index = lines.index(lines.detect {|l| l.include?('RSpec.configure do') }) + 1
          lines[configure_block_line_index...configure_block_line_index] = [
            '  # The following ensures rspec tests that instantiate and set Glimmer DSL widgets in @target get cleaned after',
            '  config.after do',
            '    @target.dispose if @target && @target.respond_to?(:dispose)',
            '    Glimmer::DSL::Engine.reset',
            '  end',
          ]
          
          lines << "\nrequire 'glimmer/rake_task'\n"
          lines.join("\n")
        end
    
        def custom_shell_file(custom_shell_name, namespace, shell_type, shell_options = {})
          namespace_type = class_name(namespace) == class_name(current_dir_name) ? 'class' : 'module'
    
          custom_shell_file_content = <<-MULTI_LINE_STRING
    #{namespace_type} #{class_name(namespace)}
      class #{class_name(custom_shell_name)}
        include Glimmer::UI::CustomShell
        
          MULTI_LINE_STRING
          
          if shell_type == :gem
            custom_shell_file_content += <<-MULTI_LINE_STRING
        APP_ROOT = File.expand_path('../../../..', __FILE__)
        VERSION = File.read(File.join(APP_ROOT, 'VERSION'))
        LICENSE = File.read(File.join(APP_ROOT, 'LICENSE.txt'))
            
            MULTI_LINE_STRING
          end
          
          custom_shell_file_content += <<-MULTI_LINE_STRING
        ## Add options like the following to configure CustomShell by outside consumers
        #
        # options :title, :background_color
        # option :width, default: 320
        # option :height, default: 240
        option :greeting, default: 'Hello, World!'
    
        ## Use before_body block to pre-initialize variables to use in body
        #
        #
          MULTI_LINE_STRING
          
          if %i[gem app desktopify].include?(shell_type)
            custom_shell_file_content += <<-MULTI_LINE_STRING
        before_body {
          Display.setAppName('#{shell_type == :gem ? human_name(custom_shell_name) : human_name(namespace)}')
          Display.setAppVersion(VERSION)
          @display = display {
            on_about {
              display_about_dialog
            }
            on_preferences {
              #{shell_type == :desktopify ? 'display_about_dialog' : 'display_preferences_dialog'}
            }
          }
        }
            MULTI_LINE_STRING
          else
            custom_shell_file_content += <<-MULTI_LINE_STRING
        # before_body {
        #
        # }
            MULTI_LINE_STRING
          end
    
          custom_shell_file_content += <<-MULTI_LINE_STRING
    
        ## Use after_body block to setup observers for widgets in body
        #
        # after_body {
        # 
        # }
    
        ## Add widget content inside custom shell body
        ## Top-most widget must be a shell or another custom shell
        #
        body {
          shell {
            # Replace example content below with custom shell content
            minimum_size #{shell_type == :desktopify ? '1024, 768' : '320, 240'}
            image File.join(APP_ROOT, 'package', 'windows', "#{human_name(shell_type == :gem ? custom_shell_name : current_dir_name)}.ico") if OS.windows?
            text "#{human_name(namespace)} - #{human_name(custom_shell_name)}"
          
          MULTI_LINE_STRING
            
          if shell_type == :desktopify
            custom_shell_file_content += <<-MULTI_LINE_STRING            
            browser {
              url "#{shell_options[:website]}"              
            }            
            MULTI_LINE_STRING
          else
            custom_shell_file_content += <<-MULTI_LINE_STRING
            grid_layout
            label(:center) {
              text bind(self, :greeting)
              font height: 40
              layout_data :fill, :center, true, true
            }            
            MULTI_LINE_STRING
          end
          
          if %i[gem app desktopify].include?(shell_type)
            custom_shell_file_content += <<-MULTI_LINE_STRING
            
            menu_bar {
              menu {
                text '&File'
                menu_item {
                  text '&About...'
                  on_widget_selected {
                    display_about_dialog
                  }
                }
                menu_item {
                  text '&Preferences...'
                  on_widget_selected {
                    #{shell_type == :desktopify ? 'display_about_dialog' : 'display_preferences_dialog'}
                  }
                }
              }
            }
            MULTI_LINE_STRING
          end
          if %i[gem app desktopify].include?(shell_type)
            custom_shell_file_content += <<-MULTI_LINE_STRING
          }
        }
            MULTI_LINE_STRING
          end
          
          if %i[gem app desktopify].include?(shell_type)
            custom_shell_file_content += <<-MULTI_LINE_STRING
    
        def display_about_dialog
          message_box(body_root) {
            text 'About'
            message "#{human_name(namespace)}#{" - #{human_name(custom_shell_name)}" if shell_type == :gem} \#{VERSION}\\n\\n\#{LICENSE}"
          }.open
        end
        
            MULTI_LINE_STRING
          end
          
          if %i[gem app].include?(shell_type)
            custom_shell_file_content += <<-MULTI_LINE_STRING
        def display_preferences_dialog
          dialog(swt_widget) {
            text 'Preferences'
            grid_layout {
              margin_height 5
              margin_width 5
            }
            group {
              row_layout {
                type :vertical
                spacing 10
              }
              text 'Greeting'
              font style: :bold
              [
                'Hello, World!', 
                'Howdy, Partner!'
              ].each do |greeting_text|
                button(:radio) {
                  text greeting_text
                  selection bind(self, :greeting) { |g| g == greeting_text }
                  layout_data {
                    width 160
                  }
                  on_widget_selected { |event|
                    self.greeting = event.widget.getText
                  }
                }
              end
            }
          }.open
        end
            MULTI_LINE_STRING
          end
          
          custom_shell_file_content += <<-MULTI_LINE_STRING
      end
    end
          MULTI_LINE_STRING
        end
    
        def custom_widget_file(custom_widget_name, namespace)
          namespace_type = class_name(namespace) == class_name(current_dir_name) ? 'class' : 'module'
    
          <<~MULTI_LINE_STRING
            #{namespace_type} #{class_name(namespace)}
              class #{class_name(custom_widget_name)}
                include Glimmer::UI::CustomWidget
            
                ## Add options like the following to configure CustomWidget by outside consumers
                #
                # options :custom_text, :background_color
                # option :foreground_color, default: :red
            
                ## Use before_body block to pre-initialize variables to use in body
                #
                #
                # before_body {
                # 
                # }
            
                ## Use after_body block to setup observers for widgets in body
                #
                # after_body {
                # 
                # }
            
                ## Add widget content under custom widget body
                ##
                ## If you want to add a shell as the top-most widget, 
                ## consider creating a custom shell instead 
                ## (Glimmer::UI::CustomShell offers shell convenience methods, like show and hide)
                #
                body {
                  # Replace example content below with custom widget content
                  label {
                    background :red
                  }
                }
            
              end
            end
          MULTI_LINE_STRING
        end
      end
    end
  end
end
