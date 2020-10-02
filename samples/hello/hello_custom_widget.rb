# This class declares a `greeting_label` custom widget (by convention)
class GreetingLabel
  include Glimmer::UI::CustomWidget
  
  # multiple options without default values
  options :name, :colors
  
  # single option with default value
  option :greeting, default: 'Hello'
  
  # internal attribute (not a custom widget option)
  attr_accessor :color
  
  before_body {
    @font = {height: 24, style: :bold}
    @color = :black
  }
  
  after_body {
    return if colors.nil?
    
    Thread.new {
      colors.cycle { |color|
        async_exec {
          self.color = color
        }
        sleep(1)
      }
    }
  }
  
  body {
    label(swt_style) { # pass received swt_style through to label
      text "#{greeting}, #{name}!"
      font @font
      foreground bind(self, :color)
    }
  }
  
end

# including Glimmer enables the Glimmer DSL syntax, including auto-discovery of the `greeting_label` custom widget
include Glimmer

shell {
  fill_layout :vertical
  
  minimum_size 215, 215
  text 'Hello, Custom Widget!'
  
  # custom widget options are passed in a hash
  greeting_label(name: 'Sean')
  
  # pass :center SWT style followed by custom widget options hash
  greeting_label(:center, name: 'Laura', greeting: 'Aloha') #
  
  greeting_label(:right, name: 'Rick') {
    # you can nest attributes under custom widgets just like any standard widget
    foreground :red
  }
  
  # the colors option cycles between colors for the label foreground every second
  greeting_label(:center, name: 'Mary', greeting: 'Aloha', colors: [:red, :dark_green, :blue])
}.open
