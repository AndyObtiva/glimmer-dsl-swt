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
          code = text
          lexer = Rouge::Lexer.find_fancy('ruby', code)
          lex = lexer.lex(code).to_a
          code_size = 0
          lex_hashes = lex.map do |pair|
            {token_type: pair.first, token_text: pair.last}
          end.each do |hash|
            hash[:token_index] = code_size
            code_size += hash[:token_text].size
          end
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
              styles = []
              line_style_event.lineOffset
              syntax_highlighting.each do |token_hash|
                if token_hash[:token_index] >= line_style_event.lineOffset && token_hash[:token_index] < (line_style_event.lineOffset + line_style_event.lineText.size)
                  start_index = token_hash[:token_index]
                  size = token_hash[:token_text].size
                  token_color = SYNTAX_COLOR_MAP[token_hash[:token_type].name] || [:black]
                  token_color = color(*token_color).swt_color
                  styles << StyleRange.new(start_index, size, token_color, nil)
                end
              end
              line_style_event.styles = styles.to_java(StyleRange) unless styles.empty?
            }            
          }
        }
      end
    end
  end
end
