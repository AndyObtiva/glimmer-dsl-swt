# Copyright (c) 2007-2022 Andy Maleh
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

require 'glimmer-dsl-swt'
require 'fileutils'

class Sample
  class << self
    def glimmer_directory
      File.expand_path('../../..', __FILE__)
    end
  
    def user_glimmer_directory
      File.join(File.expand_path('~'), '.glimmer-dsl-swt')
    end
    
    def ensure_user_glimmer_directory
      unless @ensured_glimmer_directory
        FileUtils.rm_rf(user_glimmer_directory)
        FileUtils.cp_r(glimmer_directory, user_glimmer_directory)
        @ensured_glimmer_directory = true
      end
    end
  end
  
  include Glimmer::DataBinding::ObservableModel
  
  UNEDITABLE = ['meta_sample.rb'] + (OS.windows? ? ['calculator.rb', 'weather.rb'] : [])  # Windows StyledText does not support unicode characters found in certain samples
  
  TEACHABLE = {
    'Hello, World!'                  => 'Mi5phsSdNAA',
    'Hello, Message Box!'            => 'N0sDcr0xp40',
    'Hello, Tab!'                    => 'cMwlYZ78uaQ',
    'Hello, Layout!'                 => 'dAVFR9Y_thY',
    'Hello, File Dialog!'            => 'HwZRgdvKIDo',
    'Hello, Label!'                  => 'i1PFHr-F8fQ',
    'Hello, Text!'                   => 'pOaYB43G2pg',
    'Login'                          => 'C_vSvXH9ISw',
    'Hello, Canvas Shape Listeners!' => 'PV13YE-43M4',
    'Hello, Styled Text!'            => 'ahs54DPmmso',
    'Hello, Code Text!'              => 'y0rNzMURnHY',
    'Hello, Tree!'                   => 'M-ZOFyzbEKo',
    'Hello, Table!'                  => '3zyyXq7WJwc',
  }

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
    !UNEDITABLE.include?(File.basename(file))
  end
  alias editable? editable
  
  def launchable
    File.basename(file) != 'meta_sample.rb'
  end
    
  def teachable
    !!tutorial
  end
  
  def tutorial
    TEACHABLE[name]
  end
    
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
      raise 'Unsupported through editor!' unless editable?
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
  
  before_body do
    Sample.ensure_user_glimmer_directory
    selected_sample_directory = SampleDirectory.sample_directories.first
    selected_sample = selected_sample_directory.samples.first
    selected_sample_directory.selected_sample_name = selected_sample.name
    Display.app_name = 'Glimmer Meta-Sample'
  end
  
  body {
    shell(:fill_screen) {
      minimum_size 640, 384
      text 'Glimmer Meta-Sample (The Sample of Samples)'
      image File.expand_path('../../icons/scaffold_app.png', __dir__)
      
      sash_form {
        weights 1, 2
      
        composite {
          grid_layout(1, false) {
            margin_width 0
            margin_height 0
          }
            
          expand_bar {
            layout_data(:fill, :fill, true, true)
            font height: 25
                        
            SampleDirectory.sample_directories.each { |sample_directory|
              expand_item {
                layout_data(:fill, :fill, true, true)
                text " #{sample_directory.name} Samples (#{sample_directory.samples.count})"
                
                radio_group { |radio_group_proxy|
                  row_layout(:vertical) {
                    fill true
                  }
                  selection <=> [sample_directory, :selected_sample_name]
                  font height: 20
                }
              }
            }
          }
          
          composite {
            fill_layout
            
            layout_data(:fill, :center, true, false) {
              height_hint 96
            }
            
            button {
              text 'Tutorial'
              font height: 25
              enabled <= [SampleDirectory, 'selected_sample.teachable']
              
              on_widget_selected do
                shell(:fill_screen) {
                  text "Glimmer DSL for SWT Video Tutorial - #{SampleDirectory.selected_sample.name}"
                  
                  browser {
                    text "<iframe src='https://www.youtube.com/embed/#{SampleDirectory.selected_sample.tutorial}?autoplay=1' title='YouTube video player' frameborder='0' allow='accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture' allowfullscreen style='width: 100%; height: 100%;'></iframe>"
                  }
                }.open
              end
            }
            
            button {
              text 'Launch'
              font height: 25
              enabled <= [SampleDirectory, 'selected_sample.launchable']
              
              on_widget_selected do
                begin
                  SampleDirectory.selected_sample.launch(@code_text.text)
                rescue LoadError, StandardError, SyntaxError => launch_error
                  error_dialog(message: launch_error.full_message).open
                end
              end
            }
            
            button {
              text 'Reset'
              font height: 25
              enabled <= [SampleDirectory, 'selected_sample.editable']
              
              on_widget_selected do
                SampleDirectory.selected_sample.reset_code!
              end
            }
          }
        }
            
        @code_text = code_text(lines: {width: 3}) {
          root {
            grid_layout(2, false) {
              horizontal_spacing 0
              margin_left 0
              margin_right 0
              margin_top 0
              margin_bottom 0
            }
          }
          line_numbers {
            background :white
          }
          text <=> [SampleDirectory, 'selected_sample.code']
          editable <= [SampleDirectory, 'selected_sample.editable']
          left_margin 7
          right_margin 7
        }
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
        
        on_widget_selected do
          dialog_proxy.close
        end
      }
    }
  end
end

MetaSampleApplication.launch
