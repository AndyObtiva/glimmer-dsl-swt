require 'glimmer/ui/custom_widget'

module Glimmer
  module SWT
    module Custom
      # CodeText is a customization of StyledText with support for Ruby Syntax Highlighting
      class CodeText
        include Glimmer::UI::CustomWidget
        
        class << self
          def languages
            require 'rouge'
            Rouge::Lexer.all.map {|lexer| lexer.tag}.sort
          end
          
          def lexers
            require 'rouge'
            Rouge::Lexer.all.sort_by(&:title)
          end
        end
        
        REGEX_COLOR_HEX6 = /^#([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})$/
        
        # TODO support auto language detection
        # TODO support end of line via CMD+E and beginning of line via CMD+A
        # TODO support select all via CMD+A
              
        option :language, default: 'ruby'
        # TODO consider supporting data-binding of language
        # TODO support switcher of language that automatically updates the lexer
        # TODO support method for redrawing the syntax highlighting
        option :theme, default: 'glimmer'
        option :lines, default: false
      
        alias lines? lines
        attr_accessor :styled_text_proxy_text, :styled_text_proxy_top_pixel
        attr_reader :styled_text_proxy, :lines_width
        
        def method_missing(method_name, *args, &block)
          dsl_mode = @dsl_mode || args.last.is_a?(Hash) && args.last[:dsl]
          if dsl_mode
            args.pop if args.last.is_a?(Hash) && args.last[:dsl]
            super(method_name, *args, &block)
          elsif pd(@styled_text_proxy)&.respond_to?(method_name, *args, &block)
            @styled_text_proxy&.send(method_name, *args, &block)
          else
            super
          end
        end
        
        def respond_to?(method_name, *args, &block)
          dsl_mode = @dsl_mode || args.last.is_a?(Hash) && args.last[:dsl]
          if dsl_mode
            args = args[0...-1] if args.last.is_a?(Hash) && args.last[:dsl]
            super(method_name, *args, &block)
          else
            super || @styled_text_proxy&.respond_to?(method_name, *args, &block)
          end
        end
        
        def has_instance_method?(method_name)
          respond_to?(method_name)
        end
        
        before_body {
          require 'rouge'
          require 'ext/rouge/themes/glimmer'
          @swt_style = swt_style == 0 ? [:border, :multi, :v_scroll, :h_scroll] : swt_style
          @font_name = display.get_font_list(nil, true).map(&:name).include?('Consolas') ? 'Consolas' : 'Courier'
          if lines == true
            @lines_width = 4
          elsif lines.is_a?(Hash)
            @lines_width = lines[:width]
          end
          @dsl_mode = true
        }
        
        after_body {
          @dsl_mode = nil
        }
        
        body {
          # TODO enable this once fully implemented
          if lines
            composite {
              grid_layout(2, false)
              
              @line_numbers_text = styled_text(:multi, :border) {
                layout_data(:right, :fill, false, true)
                text ' '*lines_width.to_i
                text bind(self, :styled_text_proxy_text, read_only: true) { |text_value|
                  line_count = text_value.to_s.split("\n").count
                  line_count = 1 if line_count == 0
                  lines_text_size = [line_count.to_s.size, @lines_width].max
                  if lines_text_size > @lines_width
                    async_exec { swt_widget.layout }
                    @lines_width = lines_text_size
                  end
                  line_count.times.map {|n| (' ' * (lines_text_size - (n+1).to_s.size)) + (n+1).to_s }.join("\n") + "\n"
                }
                top_pixel bind(self, :styled_text_proxy_top_pixel, read_only: true)
                font name: @font_name, height: OS.mac? ? 15 : 12
                background color(:widget_background)
                foreground :dark_blue
                top_margin 5
                right_margin 5
                bottom_margin 5
                left_margin 5
                editable false
                caret nil
                on_focus_gained {
                  @styled_text_proxy&.swt_widget.setFocus
                }
                on_key_pressed {
                  @styled_text_proxy&.swt_widget.setFocus
                }
                on_mouse_up {
                  @styled_text_proxy&.swt_widget.setFocus
                }
              }

              code_text_widget
            }
          else
            code_text_widget
          end
        }
        
        def code_text_widget
          @styled_text_proxy = styled_text(swt_style) {
            layout_data :fill, :fill, true, true if lines
            text bind(self, :styled_text_proxy_text) if lines
            top_pixel bind(self, :styled_text_proxy_top_pixel) if lines
            font name: @font_name, height: 15
            foreground rgb(75, 75, 75)
            left_margin 5
            top_margin 5
            right_margin 5
            bottom_margin 5
            
            if lines
              on_key_pressed { |event|
                character = event.keyCode.chr rescue nil
                case [event.stateMask, character]
                when [(OS.mac? ? swt(:command) : swt(:ctrl)), 'a']
                  @styled_text_proxy.swt_widget.selectAll
                when [(swt(:ctrl) unless OS.windows?), 'a']
                  jump_to_beginning_of_line
                when [(swt(:ctrl) unless OS.windows?), 'e']
                  jump_to_end_of_line
                end
              }
            end
            
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
              begin
                styles = []
                style_data = nil
                syntax_highlighting(line_style_event.lineText).to_a.each do |token_hash|
                  start_index = token_hash[:token_index]
                  size = token_hash[:token_text].size
                  style_data = Rouge::Theme.find(theme).new.style_for(token_hash[:token_type])
                  foreground_color = hex_color_to_swt_color(style_data[:fg], [:black])
                  background_color = hex_color_to_swt_color(style_data[:bg], [:white])
                  font_styles = []
                  font_styles << :bold if style_data[:bold]
                  font_styles << :italic if style_data[:italic]
                  font_style = SWTProxy[*font_styles]
                  styles << StyleRange.new(line_style_event.lineOffset + start_index, size, foreground_color, background_color, font_style)
                end
                line_style_event.styles = styles.to_java(StyleRange) unless styles.empty?
              rescue => e
                Glimmer::Config.logger.error {"Error encountered with style data: #{style_data}"}
                Glimmer::Config.logger.error {e.message}
                Glimmer::Config.logger.error {e.full_message}
              end
            }
          }
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
          require 'rouge'
          # TODO Try to use Rouge::Lexer.find_fancy('guess', code) in the future to guess the language or otherwise detect it from file extension
          @lexer ||= Rouge::Lexer.find_fancy(language)
          @lexer ||= Rouge::Lexer.find_fancy('ruby') # default to Ruby if no lexer is found
        end
        
        def hex_color_to_swt_color(color_data, default_color)
          color_data = "##{color_data.chars.drop(1).map {|c| c*2}.join}" if color_data.is_a?(String) && color_data.start_with?('#') && color_data&.size == 4
          color_data = color_data.match(REGEX_COLOR_HEX6).to_a.drop(1).map {|c| "0x#{c}".hex}.to_a if color_data.is_a?(String) && color_data.start_with?('#')
          color_data = [color_data] unless color_data.nil? || color_data.empty? || color_data.is_a?(Array)
          color_data = default_color if color_data.nil? || color_data.empty?
          color(*color_data).swt_color
        end
        
        def jump_to_beginning_of_line
          current_line_index = @styled_text_proxy.swt_widget.getLineAtOffset(@styled_text_proxy.swt_widget.getCaretOffset)
          beginning_of_current_line_offset = @styled_text_proxy.swt_widget.getOffsetAtLine(current_line_index)
          @styled_text_proxy.swt_widget.setSelection(beginning_of_current_line_offset, beginning_of_current_line_offset)
        end
        
        def jump_to_end_of_line
          current_line_index = @styled_text_proxy.swt_widget.getLineAtOffset(@styled_text_proxy.swt_widget.getCaretOffset)
          current_line = @styled_text_proxy.swt_widget.getLine(current_line_index)
          beginning_of_current_line_offset = @styled_text_proxy.swt_widget.getOffsetAtLine(current_line_index)
          new_offset = beginning_of_current_line_offset + current_line.size
          @styled_text_proxy.swt_widget.setSelection(new_offset, new_offset)
        end
      end
    end
  end
end
