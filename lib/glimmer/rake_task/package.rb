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

require 'os'

# TODO refactor to nest under RakeTask namespace
module Glimmer
  module RakeTask
    module Package
      JDK_VERSION = ' 18'
      
      class << self
        attr_accessor :jpackage_extra_args
        
        def clean
          require 'fileutils'
          FileUtils.rm_rf('dist')
          FileUtils.rm_rf('packages')
        end
        
        def gemspec
          system 'rake gemspec:generate'
        end
        
        def gem
          system 'rake build'
        end
        
        def lock_jars
          puts 'Locking gem jar-dependencies by downloading and storing in vendor/jars...'
          FileUtils.mkdir_p('vendor/jars')
          command = "lock_jars --vendor-dir vendor/jars"
          puts command
          system command
        end
        
        def config
          project_name = File.basename(File.expand_path('.'))
          if !File.exists?('config/warble.rb')
            puts 'Generating JAR configuration (config/warble.rb) to use with Warbler...'
            FileUtils.mkdir_p('config')
            if OS.windows?
              system "jruby -S gem install warbler -v2.0.5 --no-document" unless warbler_exists?
            else
              system "bash -c '#{RVM_FUNCTION}\n cd .\n jruby -S gem install warbler -v2.0.5 --no-document\n'" unless warbler_exists?
            end
            if system('warble config')
              new_config = File.read('config/warble.rb').split("\n").inject('') do |output, line|
                if line.include?('config.dirs =')
                  line = line.sub('# ', '').sub(/=[^=\n]+$/, '= %w(app bin config db docs fonts icons images lib package script sounds vendor videos)')
                end
                if line.include?('config.includes =')
                  line = line.sub('# ', '').sub(/=[^=\n]+$/, "= FileList['LICENSE.txt', 'VERSION']")
                end
                if line.include?('config.autodeploy_dir =')
                  line = line.sub('# ', '')
                end
                output + "\n" + line
              end
              File.write('config/warble.rb', new_config)
            else
              puts 'Warbler executable "warble" is missing!'
            end
          end
        end
        
        def jar
          FileUtils.mkdir_p('dist')
          puts "Generating JAR with Warbler..."
          system "jruby -S gem install warbler -v2.0.5 --no-document" unless warbler_exists?
          system('warble')
        end
        
        def native(native_type=nil, native_extra_args)
          puts "Generating native executable with jpackage..."
          java_version = `jruby -v`
          if java_version.include?(JDK_VERSION)
            puts "Java Version #{JDK_VERSION} Detected!"
          else
            puts "WARNING! Glimmer Packaging Pre-Requisite Java Version #{JDK_VERSION} Is Not Found!"
          end
          require 'facets/string/titlecase'
          require 'facets/string/underscore'
          require 'facets/string/camelcase'
          project_name = File.basename(File.expand_path('.'))
          version_file = File.expand_path('./VERSION')
          version = (File.read(version_file).strip if File.exists?(version_file) && File.file?(version_file)) rescue nil
          license_file = File.expand_path('./LICENSE.txt')
          license = (File.read(license_file).strip if File.exists?(license_file) && File.file?(license_file)) rescue nil
          copyright = license.split("\n").first
          human_name = project_name.underscore.titlecase
          icon = "icons/#{OS.mac? ? 'macosx' : (OS.linux? ? 'linux' : 'windows')}/#{human_name}.#{OS.mac? ? 'icns' : (OS.linux? ? 'png' : 'ico')}"
          native_type = 'app-image' if native_type.to_s.strip.empty?
          if (`jpackage`.to_s.include?('Usage: jpackage') rescue nil)
            FileUtils.rm_rf("packages/bundles")
            FileUtils.mkdir_p('packages/bundles')
            command = "jpackage"
            command += " --type #{native_type}"
            command += " --dest 'packages/bundles' --input 'dist' --main-class JarMain --main-jar '#{project_name}.jar' --name '#{human_name}' --vendor '#{human_name}' --icon '#{icon}' "
            command += " --win-per-user-install --win-dir-chooser --win-menu --win-menu-group '#{human_name}' " if OS.windows? && native_type != 'app-image'
            command += " --linux-menu-group '#{human_name}' " if OS.linux? && native_type != 'app-image'
            command += " --java-options '-XstartOnFirstThread' --mac-package-name '#{human_name}' --mac-package-identifier 'org.#{project_name}.application.#{project_name}' " if OS.mac?
            command += " --app-version \"#{version}\" " if version
            command += " --license-file LICENSE.txt " if license && native_type != 'app-image'
            command += " --copyright \"#{copyright}\" " if copyright
          else
            puts "jpackage does not exist in your Java installation. Please ensure jpackage is available in PATH environment variable."
            return
          end
          Rake.application.load_rakefile # make sure to load potential jpackage_extra_args config in app Rakefile
          command += " #{jpackage_extra_args} " if jpackage_extra_args
          command += " #{ENV['JPACKAGE_EXTRA_ARGS']} " if ENV['JPACKAGE_EXTRA_ARGS']
          command += " #{native_extra_args} " if native_extra_args
          puts command
          system command
        end
        
        private
        
        def warbler_exists?
          OS.windows? ? system('where warble') : system('which warble')
        end
      end
    end
  end
end
