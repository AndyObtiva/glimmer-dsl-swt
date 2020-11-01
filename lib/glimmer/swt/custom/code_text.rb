require 'glimmer/ui/custom_widget'

module Glimmer
  module SWT
    module Custom
      # CodeText is a customization of StyledText with support for Ruby Syntax Highlighting
      class CodeText
        include Glimmer::UI::CustomWidget
        
        SYNTAX_COLOR_MAP = {
           Builtin:     [215,58,73], 
           Class:       [3,47,98], 
           Constant:    [0,92,197], 
           Double:      [0,92,197],
           Escape:      [:red],
           Function:    [:blue], 
           Instance:    [227,98,9], 
           Integer:     [:blue], 
           Interpol:    [:blue],
           Keyword:     [:blue], 
           Name:        [111,66,193], #purple
           Operator:    [:red], 
           Pseudo:      [:dark_red],
           Punctuation: [:blue], 
           Single:      [106,115,125], # Also, Comments
           Symbol:      [:dark_green],
           Text:        [75, 75, 75],
        }
        
        # TODO support `option :language`
        # TODO support auto language detection
      
        def text=(value)
          swt_widget&.text = value
        end
        
        def text
          swt_widget&.text
        end
        
        def syntax_highlighting          
          return [] if text.to_s.strip.empty?
          return @syntax_highlighting if already_syntax_highlighted?
          @last_text = text
          @lexer ||= Rouge::Lexer.find_fancy('ruby', text)
          lex = @lexer.lex(text).to_a
          text_size = 0
          lex_hashes = lex.map do |pair|
            {token_type: pair.first, token_text: pair.last}
          end.each do |hash|
            hash[:token_index] = text_size
            text_size += hash[:token_text].size
          end
          text_lines = text.split("\n")
          line_index = 0
          @syntax_highlighting = text_lines_map = text_lines.reduce({}) do |hash, line|
            line_hashes = []
            line_hashes << lex_hashes.shift while lex_hashes.any? && lex_hashes.first[:token_index].between?(line_index, line_index + line.size)
            hash.merge(line_index => line_hashes).tap do
              line_index += line.size + 1
            end            
          end          
        end
        
        def already_syntax_highlighted?
          @last_text == text
        end
        
        before_body {
          @swt_style = swt_style == 0 ? [:border, :multi, :v_scroll, :h_scroll] : swt_style
        }
        
        body {
          styled_text(swt_style) {
            font name: 'Consolas', height: 15
            foreground rgb(75, 75, 75)
            left_margin 5
            top_margin 5
            right_margin 5
            bottom_margin 5
                  
            on_line_get_style { |line_style_event|
              @styles ||= {}
              @styles = {} unless already_syntax_highlighted?
              if @styles[line_style_event.lineOffset].nil?
                styles = []
                syntax_highlighting[line_style_event.lineOffset].to_a.each do |token_hash|
                  start_index = token_hash[:token_index]
                  size = token_hash[:token_text].size
                  token_color = SYNTAX_COLOR_MAP[token_hash[:token_type].name] || [:black]
                  token_color = color(*token_color).swt_color
                  styles << StyleRange.new(start_index, size, token_color, nil)
                end
                @styles[line_style_event.lineOffset] = styles.to_java(StyleRange)
              end
              line_style_event.styles = @styles[line_style_event.lineOffset] unless @styles[line_style_event.lineOffset].empty?
            }            
          }
        }
      end
    end
  end
end
