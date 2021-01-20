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
        
        def syntax_highlighting(text)
          return [] if text.to_s.strip.empty?
          @syntax_highlighting ||= {}
          unless @syntax_highlighting.keys.include?(text)
            lex = lexer.lex(text).to_a
            text_size = 0
            @syntax_highlighting[text] = lex.map do |pair|
              {token_type: pair.first, token_text: pair.last}
            end.each do |hash|
              hash[:token_index] = text_size
              text_size += hash[:token_text].size
            end
          end
          @syntax_highlighting[text]
        end
        
        def lexer
          # TODO Try to use Rouge::Lexer.find_fancy('guess', code) in the future to guess the language or otherwise detect it from file extension
          @lexer ||= Rouge::Lexer.find_fancy('ruby')
        end
        
        before_body {
          @swt_style = swt_style == 0 ? [:border, :multi, :v_scroll, :h_scroll] : swt_style
          @font_name = display.get_font_list(nil, true).map(&:name).include?('Consolas') ? 'Consolas' : 'Courier'
        }
        
        body {
          styled_text(swt_style) {
            font name: @font_name, height: 15
            foreground rgb(75, 75, 75)
            left_margin 5
            top_margin 5
            right_margin 5
            bottom_margin 5
            
            on_modify_text { |event|
              # clear unnecessary syntax highlighting cache on text updates, and do it async to avoid affecting performance
              new_text = event.data
              async_exec {
                unless @syntax_highlighting.nil?
                  lines = new_text.to_s.split("\n")
                  line_diff = @syntax_highlighting.keys - lines
                  line_diff.each do |line|
                    @syntax_highlighting.delete(line)
                  end
                end
              }
            }
                  
            on_line_get_style { |line_style_event|
              styles = []
              syntax_highlighting(line_style_event.lineText).to_a.each do |token_hash|
                start_index = token_hash[:token_index]
                size = token_hash[:token_text].size
                token_color = SYNTAX_COLOR_MAP[token_hash[:token_type].name] || [:black]
                token_color = color(*token_color).swt_color
                styles << StyleRange.new(line_style_event.lineOffset + start_index, size, token_color, nil)
              end
              line_style_event.styles = styles.to_java(StyleRange) unless styles.empty?
            }
          }
        }
      end
    end
  end
end
