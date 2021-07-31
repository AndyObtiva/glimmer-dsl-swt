require 'glimmer-dsl-swt'
require 'bigdecimal'

require_relative 'calculator/model/presenter'

# This sample demonstrates use of MVP (Model-View-Presenter) Architectural Pattern
# to data-bind View widgets to object-oriented Models taking advantage of design patterns
# like Command Design Pattern.
class Calculator
  include Glimmer::UI::CustomShell
  
  BUTTON_FONT = {height: 14}
  BUTTON_FONT_OPERATION = {height: 18}
  BUTTON_FONT_BIG = {height: 28}

  attr_reader :presenter

  before_body do
    @presenter = Model::Presenter.new
    
    Display.setAppName('Glimmer Calculator')
    
    display {
      on_swt_keydown { |key_event|
        char = key_event.character.chr rescue nil
        @presenter.press(char)
      }
      
      on_about {
        display_about_dialog
      }
    }
  end

  body {
    shell {
      grid_layout 4, true
      
      minimum_size (OS.mac? ? 320 : (OS.windows? ? 390 : 520)), 240
      text "Glimmer Calculator"
      
      on_shell_closed do
        @presenter.purge_command_history
      end
      
      # Setting styled_text to multi in order for alignment options to activate
      styled_text(:multi, :wrap, :border) {
        text <= [@presenter, :result]
        alignment swt(:right)
        right_margin 5
        font height: 40
        layout_data(:fill, :fill, true, true) {
          horizontal_span 4
        }
        editable false
        caret nil
      }
      command_button('AC')
      operation_button('÷')
      operation_button('×')
      operation_button('−')
      (7..9).each { |number|
        number_button(number)
      }
      operation_button('+', font: BUTTON_FONT_BIG, vertical_span: 2)
      (4..6).each { |number|
        number_button(number)
      }
      (1..3).each { |number|
        number_button(number)
      }
      command_button('=', font: BUTTON_FONT_BIG, vertical_span: 2)
      number_button(0, horizontal_span: 2)
      operation_button('.')
    }
  }
  
  def number_button(number, options = {})
    command_button(number, options)
  end
  
  def operation_button(operation, options = {})
    command_button(operation, options.merge(font: BUTTON_FONT_OPERATION))
  end
  
  def command_button(command, options = {})
    command = command.to_s
    options[:font] ||= BUTTON_FONT
    options[:horizontal_span] ||= 1
    options[:vertical_span] ||= 1
    
    button { |proxy|
      text command
      font options[:font]
      
      layout_data(:fill, :fill, true, true) {
        horizontal_span options[:horizontal_span]
        vertical_span options[:vertical_span]
      }
      
      on_widget_selected {
        @presenter.press(command)
      }
    }
  end

  def display_about_dialog
    message_box(body_root) {
      text 'About'
      message "Glimmer - Calculator\n\nCopyright (c) 2007-2021 Andy Maleh"
    }.open
  end

end

Calculator.launch
