require 'os'

# TODO refactor to nest under RakeTask namespace

module Glimmer
  module Package
    class << self
      attr_accessor :javapackager_extra_args
      
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
        puts 'Locking JARs with jar-dependencies...'
        command = "lock_jars --vendor-dir vendor"
        puts command
        system command      
      end
      
      def native
        puts "Generating native executable with javapackager..."
        require 'facets/string/titlecase'
        require 'facets/string/underscore'
        project_name = File.basename(File.expand_path('.'))
        version_file = File.expand_path('./VERSION')
        version = (File.read(version_file).strip if File.exists?(version_file) && File.file?(version_file)) rescue nil
        license_file = File.expand_path('./LICENSE.txt')
        license = (File.read(license_file).strip if File.exists?(license_file) && File.file?(license_file)) rescue nil
        copyright = license.split("\n").first
        human_name = project_name.underscore.titlecase
        command = "javapackager -deploy -native -outdir packages -outfile \"#{project_name}\" -srcfiles \"dist/#{project_name}.jar\" -appclass JarMain -name \"#{human_name}\" -title \"#{human_name}\" -Bmac.CFBundleName=\"#{human_name}\" -Bmac.CFBundleIdentifier=\"org.#{project_name}.application.#{project_name}\" -Bmac.category=\"public.app-category.business\" -BinstalldirChooser=true -Bvendor=\"#{human_name}\" -Bwin.menuGroup=\"#{human_name}\" -BsystemWide=#{OS.mac?} "
        command += " -BjvmOptions=-XstartOnFirstThread " if OS.mac?
        command += " -BappVersion=#{version} -Bmac.CFBundleVersion=#{version} " if version
        command += " -srcfiles LICENSE.txt -BlicenseFile=LICENSE.txt " if license
        command += " -Bcopyright=\"#{copyright}\" " if copyright
        command += " #{javapackager_extra_args} " if javapackager_extra_args
        command += " #{ENV['JAVAPACKAGER_EXTRA_ARGS']} " if ENV['JAVAPACKAGER_EXTRA_ARGS']
        puts command
        system command      
      end
    end
  end
end
