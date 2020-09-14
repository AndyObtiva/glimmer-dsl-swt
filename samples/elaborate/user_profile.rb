include Glimmer

shell {
  text "User Profile"

  composite {
    grid_layout 2, false

    group {
      text "Name"
      grid_layout 2, false
      layout_data :fill, :fill, true, true
      label {text "First"}; text {text "Bullet"}
      label {text "Last"}; text {text "Tooth"}  
    }

    group {
      layout_data :fill, :fill, true, true
      text "Gender"
      radio {text "Male"; selection true}
      radio {text "Female"}  
    }

    group {
      layout_data :fill, :fill, true, true
      text "Role"
      check {text "Student"; selection true}
      check {text "Employee"; selection true}  
    }

    group {
      text "Experience"
      row_layout
      layout_data :fill, :fill, true, true
      spinner {selection 5}; label {text "years"}
    }

    button {
      text "save"
      layout_data :right, :center, true, true
      on_widget_selected { 
        message_box {
          text 'Profile Saved!'
          message 'User profile has been saved!'
        }.open 
      }
    }

    button {
      text "close"
      layout_data :left, :center, true, true
      on_widget_selected { exit(0) }
    }
  }
}.open
