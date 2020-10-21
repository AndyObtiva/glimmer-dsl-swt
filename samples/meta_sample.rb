require 'rouge'

# TODO include meta-sample's code in code to display but not launch
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
    @content ||= File.read(file)
  end
  
  def syntax_highlighting
    code = content
    lexer = Rouge::Lexer.find_fancy('ruby', code)
    lex = lexer.lex(code).to_a
    code_size = 0
    lex_hashes = lex.map do |pair|
      {token_type: pair.first, token_text: pair.last}
    end.each do |hash|
      hash[:token_index] = code_size
      code_size += hash[:token_text].size
    end.reject do |hash|
      hash[:token_type] == Rouge::Token::Tokens::Text
    end
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
            # TODO sort by having hello first, elaborate second, and everything else after
      end
      @sample_directories
    end
    
    def all_samples
      @all_samples ||= sample_directories.map(&:samples).reduce(:+)
    end
  end
  
  include Glimmer # used for observe syntax
  
  attr_accessor :file
  
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
end

class MetaSampleApplication
  include Glimmer
  
  def launch
    # TODO open samples from all gems as per the Glimmer sample:list Rake Task (reuse its code)
    shell {
      text 'Glimmer Meta Sample (The Sample of Samples)'
      
      on_swt_show {
        SampleDirectory.selected_sample = SampleDirectory.all_samples.first
      }
      
      sash_form {
        composite {
          grid_layout 1, false
          
          scrolled_composite {
            layout_data(:fill, :fill, true, true)
            
            composite {
              SampleDirectory.sample_directories.each { |sample_directory|
                group {
                  layout_data(:fill, :fill, true, true)
                  grid_layout 2, false
                  text sample_directory.name
                  font height: 30
                  
                  sample_directory.samples.each { |sample|
                    label_radio = radio {
                      selection bind(sample, :selected)
                    }
                    label {
                      text sample.name
                      font height: 30
                      
                      on_mouse_up {
                        sample.selected = true
                      }
                    }
                  }
                }
              }
            }
          }
          
          button {
            layout_data(:center, :center, true, true) {
              height_hint 150
            }
            text 'Launch Sample'
            font height: 45
            on_widget_selected {
              SampleDirectory.selected_sample.launch
            }
          }
        }
            
        # TODO extract the following to a code_text widget that has syntax highlighting and language detection
        styled_text(:multi, :border, :v_scroll, :h_scroll) { |proxy|
          text bind(SampleDirectory, 'selected_sample.content')
          font name: 'Lucida Console', height: 16
          foreground rgb(75, 75, 75)
          editable false
          caret nil
          left_margin 5
          top_margin 5
          right_margin 5
          bottom_margin 5
            
          lex_color_map = {
             Builtin: rgb(215,58,73), 
             Class: rgb(3,47,98), 
             Constant: rgb(0,92,197), 
             Double: rgb(0,92,197),
             Escape: color(:red),
             Function: color(:blue), 
             Instance: rgb(227,98,9), 
             Integer: color(:blue), 
             Keyword: color(:blue), 
             Name: rgb(111,66,193), #purple
             Operator: color(:red), 
             Punctuation: color(:blue), 
             Single: rgb(106,115,125), # Also, Comments
             Symbol: color(:dark_green),
             Pseudo: color(:dark_red),
             Interpol: color(:blue),
          }       
          on_line_get_style { |line_style_event|
            styles = []
            line_style_event.lineOffset
            SampleDirectory.selected_sample.syntax_highlighting.each do |token_hash|
              if token_hash[:token_index] >= line_style_event.lineOffset && token_hash[:token_index] < (line_style_event.lineOffset + line_style_event.lineText.size)
                start_index = token_hash[:token_index]
                size = token_hash[:token_text].size
                token_color = (lex_color_map[token_hash[:token_type].name] || color(:black)).swt_color
                styles << StyleRange.new(start_index, size, token_color, nil)
              end
            end
            line_style_event.styles = styles.to_java(StyleRange) unless styles.empty?
          }
        }
        
        weights [1, 2]
      }
    }.open
  end
end

MetaSampleApplication.new.launch
