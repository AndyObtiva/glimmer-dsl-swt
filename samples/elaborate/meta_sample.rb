class Sample
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
  
  def content
    @content = File.read(file)
  end
    
  def launch
    load file
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
  include Glimmer
  
  def launch
    shell {
      minimum_size 1280, 768
      text 'Glimmer Meta-Sample (The Sample of Samples)'
      
      on_swt_show {
        SampleDirectory.selected_sample = SampleDirectory.all_samples.first        
      }
      
      sash_form {
        composite {
          grid_layout 1, false
            
          expand_bar {
            layout_data(:fill, :fill, true, true)
            font height: 30
                        
            SampleDirectory.sample_directories.each { |sample_directory|
              expand_item {
                layout_data(:fill, :fill, true, true)
                text "#{sample_directory.name} Samples"
                
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
          
          button {
            layout_data(:fill, :center, true, false) {
              height_hint 120
            }
            text 'Launch Sample'
            font height: 30
            on_widget_selected {
              SampleDirectory.selected_sample.launch
            }
          }        
        }
            
        code_text {
          text bind(SampleDirectory, 'selected_sample.content')
          editable false
          caret nil
        }
        
        weights 4, 9
      }            
    }.open
  end
end

MetaSampleApplication.new.launch
