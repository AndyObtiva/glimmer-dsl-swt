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

require 'fileutils'
require 'etc'

class Sample
  include Glimmer::DataBinding::ObservableModel
  
  class << self
    def glimmer_directory
      File.expand_path('../../..', __FILE__)
    end
  
    def user_glimmer_directory
      File.join(Etc.getpwuid.dir, '.glimmer-dsl-swt')
    end
    
    def ensure_user_glimmer_directory
      unless @ensured_glimmer_directory
        FileUtils.rm_rf(user_glimmer_directory)
        FileUtils.cp_r(glimmer_directory, user_glimmer_directory)
        @ensured_glimmer_directory = true
      end
    end
  end

  attr_accessor :sample_directory, :file, :selected
  
  def initialize(file, sample_directory: )
    self.file = file
    self.sample_directory = sample_directory
  end
  
  def name
    if @name.nil?
      @name = File.basename(file, '.rb').split('_').map(&:capitalize).join(' ')
      if @name.start_with?('Hello')
        name_parts = @name.split
        name_parts[0] = name_parts.first + ','
        name_parts[-1] = name_parts.last + '!'
        @name = name_parts.join(' ')
      end
    end
    @name
  end
  
  def code
    reset_code! if @code.nil?
    @code
  end
  
  def reset_code!
    @code = File.read(file)
    notify_observers('code')
  end
  
  def editable
    File.basename(file) != 'meta_sample.rb'
  end
  alias launchable editable
    
  def file_relative_path
    file.sub(self.class.glimmer_directory, '')
  end
  
  def user_file
    File.join(self.class.user_glimmer_directory, file_relative_path)
  end
    
  def user_file_parent_directory
    File.dirname(user_file)
  end
  
  def directory
    file.sub(/\.rb/, '')
  end
    
  def launch(modified_code)
    launch_file = user_file
    begin
      FileUtils.cp_r(file, user_file_parent_directory)
      FileUtils.cp_r(directory, user_file_parent_directory) if File.exist?(directory)
      File.write(user_file, modified_code)
    rescue => e
      puts 'Error writing sample modifications. Launching original sample.'
      puts e.full_message
      launch_file = file # load original file if failed to write changes
    end
    load(launch_file)
  end
end

class SampleDirectory
  class << self
    attr_accessor :selected_sample
    
    def sample_directories
      if @sample_directories.nil?
        @sample_directories = Dir.glob(File.join(File.expand_path('..', __FILE__), '*')).
            select { |file| File.directory?(file) }.
            map { |file| SampleDirectory.new(file) }
        glimmer_gems = Gem.find_latest_files("glimmer-*-*")
        sample_directories = glimmer_gems.map do |lib|
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
        sample_directories = sample_directories.uniq {|dir| File.basename(dir)}
        @sample_directories = sample_directories.map { |file| SampleDirectory.new(file) }
      end
      @sample_directories
    end
    
    def all_samples
      @all_samples ||= sample_directories.map(&:samples).reduce(:+)
    end
  end
  
  include Glimmer # used for observe syntax
  
  attr_accessor :file, :selected_sample_name
  
  def initialize(file)
    self.file = file
  end
  
  def name
    File.basename(file).split('_').map(&:capitalize).join(' ')
  end
  
  def samples
    if @samples.nil?
      @samples = Dir.glob(File.join(file, '*')).
          select { |file| File.file?(file) }.
          map { |sample_file| Sample.new(sample_file, sample_directory: self) }.
          sort_by(&:name)
      
      @samples.each do |sample|
        observe(sample, :selected) do |new_selected_value|
          if new_selected_value
            self.class.all_samples.reject {|a_sample| a_sample.name == sample.name}.each do |other_sample|
              other_sample.selected = false
            end
            self.class.selected_sample = sample
          end
        end
      end
    end
    @samples
  end
  
  def selected_sample_name_options
    samples.map(&:name)
  end
  
  def selected_sample_name=(selected_name)
    @selected_sample_name = selected_name
    unless selected_name.nil?
      (self.class.sample_directories - [self]).each { |sample_dir| sample_dir.selected_sample_name = nil }
      self.class.selected_sample = samples.detect { |sample| sample.name == @selected_sample_name }
    end
  end
  
end

class MetaSampleApplication
  include Glimmer::UI::CustomShell
  
  before_body {
    Sample.ensure_user_glimmer_directory
    selected_sample_directory = SampleDirectory.sample_directories.first
    selected_sample = selected_sample_directory.samples.first
    selected_sample_directory.selected_sample_name = selected_sample.name
    Display.app_name = 'Glimmer Meta-Sample'
  }
  
  body {
    shell(:fill_screen) {
      minimum_size 1280, 768
      text 'Glimmer Meta-Sample (The Sample of Samples)'
      image File.expand_path('meta_sample/meta_sample_logo.png', __dir__)
      
      sash_form {
        composite {
          grid_layout(1, false) {
            margin_width 0
            margin_height 0
          }
            
          expand_bar {
            layout_data(:fill, :fill, true, true)
            font height: 30
                        
            SampleDirectory.sample_directories.each { |sample_directory|
              expand_item {
                layout_data(:fill, :fill, true, true)
                text " #{sample_directory.name} Samples"
                
                radio_group { |radio_group_proxy|
                  row_layout(:vertical) {
                    fill true
                  }
                  selection bind(sample_directory, :selected_sample_name)
                  font height: 24
                }
              }
            }
          }
          
          composite {
            fill_layout
            layout_data(:fill, :center, true, false) {
              height_hint 120
            }
            
            button {
              text 'Launch'
              font height: 30
              enabled bind(SampleDirectory, 'selected_sample.launchable')
              
              on_widget_selected {
                begin
                  SampleDirectory.selected_sample.launch(@code_text.text)
                rescue LoadError, StandardError, SyntaxError => launch_error
                  error_dialog(message: launch_error.full_message).open
                end
              }
            }
            button {
              text 'Reset'
              font height: 30
              enabled bind(SampleDirectory, 'selected_sample.editable')
              
              on_widget_selected {
                SampleDirectory.selected_sample.reset_code!
              }
            }
          }
        }
            
        @code_text = code_text(lines: {width: 2}) {
          text bind(SampleDirectory, 'selected_sample.code', read_only: true)
          editable bind(SampleDirectory, 'selected_sample.editable')
          line_numbers {
            background :white
          }
        }
        
        weights 4, 11
      }
    }
  }
  
  # Method-based error_dialog custom widget
  def error_dialog(message:)
    return if message.nil?
    dialog(body_root) { |dialog_proxy|
      row_layout(:vertical) {
        center true
      }
      
      text 'Error Launching'
        
      styled_text(:border, :h_scroll, :v_scroll) {
        layout_data {
          width body_root.bounds.width*0.75
          height body_root.bounds.height*0.75
        }
        
        text message
        editable false
        caret nil
      }
      
      button {
        text 'Close'
        
        on_widget_selected {
          dialog_proxy.close
        }
      }
    }
  end
end

MetaSampleApplication.launch
