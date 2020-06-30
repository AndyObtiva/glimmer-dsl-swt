class Location
  attr_accessor :country
  
  def country_options
    %w[USA Canada Mexico Columbia UK Australia Germany Italy Spain]
  end
end

@location = Location.new

include Glimmer

shell {
  text 'Hello, Drag and Drop!'
  list {
    selection bind(@location, :country)
    on_drag_set_data { |event|
      list = event.widget.getControl
      event.data = list.getSelection.first
    }
  }
  label(:center) {
    text 'Drag a country here!'
    font height: 20
    on_drop { |event|
      event.widget.getControl.setText(event.data)
    }
  }
}.open
