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

require 'os'

# TODO refactor to nest under RakeTask namespace

module Glimmer
  module Package
    class << self
      attr_accessor :javapackager_extra_args
      alias jpackage_extra_args :javapackager_extra_args
      
      def clean
        require 'fileutils'
        FileUtils.rm_rf('dist')
        FileUtils.rm_rf('packages')
      end
      
      def config
        project_name = File.basename(File.expand_path('.'))
        if !File.exists?('config/warble.rb')
          puts 'Generating JAR configuration (config/warble.rb) to use with Warbler...'
          FileUtils.mkdir_p('config')
          system('warble config')
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
        end      
      end
      
      def jar
        FileUtils.mkdir_p('dist')
        puts "Generating JAR with Warbler..."
        system('warble')      
      end
      
      def lock_jars
        puts 'Locking gem jar-dependencies by downloading & storing in vendor/jars...'
        FileUtils.mkdir_p('vendor/jars')
        command = "lock_jars --vendor-dir vendor/jars"
        puts command
        system command      
      end
      
      def native(native_type=nil, native_extra_args)
        puts "Generating native executable with javapackager/jpackage..."
        require 'facets/string/titlecase'
        require 'facets/string/underscore'
        project_name = File.basename(File.expand_path('.'))
        version_file = File.expand_path('./VERSION')
        version = (File.read(version_file).strip if File.exists?(version_file) && File.file?(version_file)) rescue nil
        license_file = File.expand_path('./LICENSE.txt')
        license = (File.read(license_file).strip if File.exists?(license_file) && File.file?(license_file)) rescue nil
        copyright = license.split("\n").first
        human_name = project_name.underscore.titlecase
        icon = "package/#{OS.mac? ? 'macosx' : 'windows'}/#{human_name}.#{OS.mac? ? 'icns' : 'ico'}"
        if (`javapackager`.to_s.include?('Usage: javapackager') rescue nil)
          command = "javapackager -deploy -native #{native_type} -outdir packages -outfile \"#{project_name}\" -srcfiles \"dist/#{project_name}.jar\" -appclass JarMain -name \"#{human_name}\" -title \"#{human_name}\" -Bmac.CFBundleName=\"#{human_name}\" -Bmac.CFBundleIdentifier=\"org.#{project_name}.application.#{project_name}\" -Bmac.category=\"public.app-category.business\" -BinstalldirChooser=true -Bvendor=\"#{human_name}\" -Bwin.menuGroup=\"#{human_name}\" "
          command += " -BsystemWide=false " if OS.windows?
          command += " -BjvmOptions=-XstartOnFirstThread " if OS.mac?
          command += " -BappVersion=#{version} -Bmac.CFBundleVersion=#{version} " if version
          command += " -srcfiles LICENSE.txt -BlicenseFile=LICENSE.txt " if license
          command += " -Bcopyright=\"#{copyright}\" " if copyright
        elsif (`jpackage`.to_s.include?('Usage: jpackage') rescue nil)
          command = "jpackage --type #{native_type} --dest 'packages/bundles' --input 'dist' --main-class JarMain --main-jar '#{project_name}.jar' --name '#{human_name}' --vendor '#{human_name}' --icon '#{icon}' "
          command += " --win-per-user-install --win-dir-chooser --win-menu --win-menu-group '#{human_name}' " if OS.windows?
          command += " --java-options '-XstartOnFirstThread' --mac-package-name '#{human_name}' --mac-package-identifier 'org.#{project_name}.application.#{project_name}' " if OS.mac?
          command += " --app-version \"#{version}\" " if version
          command += " --license-file LICENSE.txt " if license
          command += " --copyright \"#{copyright}\" " if copyright
        else
          puts "Neither javapackager nor jpackage exist in your Java installation. Please ensure javapackager or jpackage is available in PATH environment variable."
          return
        end
        command += " #{javapackager_extra_args} " if javapackager_extra_args
        command += " #{ENV['JAVAPACKAGER_EXTRA_ARGS']} " if ENV['JAVAPACKAGER_EXTRA_ARGS']
        command += " #{native_extra_args} " if native_extra_args
        puts command
        system command      
      end
    end
  end
end
