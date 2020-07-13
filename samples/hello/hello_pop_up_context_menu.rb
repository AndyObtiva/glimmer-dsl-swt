include Glimmer

shell { |shell_proxy|
  text 'Hello, Pop Up Context Menu!'
  grid_layout
  label {
    font height: 16
    text 'Right-Click To Pop Up a Context Menu'
    menu {
      menu {
        text '&History'
        menu {
          text '&Recent'
          menu_item {
            text 'File 1'
            on_widget_selected {
              message_box(shell_proxy) {
                text 'File 1'
                message 'File 1 Contents'
              }.open
            }
          }
          menu_item {
            text 'File 2'
            on_widget_selected {
              message_box(shell_proxy) {
                text 'File 2'
                message 'File 2 Contents'
              }.open
            }
          }
        }
      }
    }
  }
}.open
