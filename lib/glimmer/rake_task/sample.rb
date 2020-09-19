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

require 'text-table'
require 'facets/string/titlecase'
require 'facets/string/underscore'

require_relative '../launcher'

module Glimmer
  module RakeTask
    # Lists Glimmer related gems to use in rake_task.rb
    class Sample
      class << self
        def glimmer_gems(glimmer_gem_type = '*')
          Gem.find_latest_files("glimmer-#{glimmer_gem_type}-*")
        end
        
        def glimmer_gem_libs(glimmer_gem_type = '*')
          glimmer_gems(glimmer_gem_type).map {|file| file.sub(/\.rb$/, '')}.uniq.reject {|file| file.include?('glimmer-cs-gladiator')}
        end
        
        def glimmer_gem_samples(glimmer_gem_type = '*')
          sample_directories = glimmer_gems(glimmer_gem_type).map do |lib| 
            File.dirname(File.dirname(lib))
          end.select do |gem| 
            Dir.exist?(File.join(gem, 'samples'))
          end.map do |gem| 
            Dir.glob(File.join(gem, 'samples', '*')).select {|file_or_dir| Dir.exist?(file_or_dir)}
          end.flatten.uniq.reverse
          if Dir.exist?('samples')
            Dir.glob(File.join('samples', '*')).to_a.reverse.each do |dir|
              sample_directories << dir if Dir.exist?(dir)
            end
          end
          sample_directories.uniq {|dir| File.basename(dir)}
        end
        
        def run(name)
          name = name.underscore.downcase unless name.nil?
          samples = glimmer_gem_samples.map {|dir| Dir.glob(File.join(dir, '*.rb'))}.reduce(:+).sort
          samples = samples.select {|path| path.include?("#{name}.rb")} unless name.nil?      
          Rake::Task['glimmer:sample:code'].invoke(name) if samples.size == 1
          Glimmer::Launcher.new(samples << '--quiet=false').launch        
        end
        
        def list(query)
          glimmer_gem_samples.each do |dir|
            sample_group_name = File.basename(dir)
            human_sample_group_name = sample_group_name.underscore.titlecase
            array_of_arrays = Dir.glob(File.join(dir, '*.rb')).map do |path| 
              File.basename(path, '.rb')
            end.select do |path| 
              query.nil? || path.include?(query)
            end.map do |path| 
              [path, path.underscore.titlecase, "#{'bin/' if Glimmer::Launcher.dev_mode?}glimmer sample:run[#{path}]"]
            end.sort
            if array_of_arrays.empty?
              puts "No Glimmer #{human_sample_group_name} Samples match the query."
            else
              puts 
              puts "  Glimmer #{human_sample_group_name} Samples:"
              puts Text::Table.new(
                :head => %w[Name Description Run],
                :rows => array_of_arrays,
                :horizontal_padding    => 1,
                :vertical_boundary     => ' ',
                :horizontal_boundary   => ' ',
                :boundary_intersection => ' '
              )        
            end
          end        
        end
        
        def code(name)
          require 'tty-markdown' unless OS.windows?
          samples = glimmer_gem_samples.map {|dir| Dir.glob(File.join(dir, '*.rb'))}.reduce(:+).sort
          sample = samples.detect {|path| path.include?("#{name.to_s.underscore.downcase}.rb")}
          sample_additional_files = Dir.glob(File.join(sample.sub('.rb', ''), '**', '*.rb'))
          code = ([sample] + sample_additional_files).map do |file|
            <<~RUBY
            
            # #{file}
            
            #{File.read(file)}
            
            # # #
            
            RUBY
          end.join("\n")
          code = TTY::Markdown.parse("```ruby\n#{code}\n```") unless OS.windows?
          puts code        
        end
      end
    end
  end
end
