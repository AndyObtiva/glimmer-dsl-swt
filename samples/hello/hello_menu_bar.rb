include Glimmer

shell { |shell_proxy|
  text 'Hello, Menu Bar!'
  grid_layout
  label(:center) {
    font height: 16
    text 'Check Out The File Menu and History Menu in The Menu Bar Above!'
  }
  menu_bar {
    menu {
      text '&File'
      menu_item {
        text 'E&xit'
        on_widget_selected {
          exit(0)
        }
      }
      menu_item(0) {
        text '&New'
        on_widget_selected {
          message_box(shell_proxy) {
            text 'New File'
            message 'New File Contents'
          }.open
        }
      }
      menu(1) {
        text '&Options'
        menu_item(:radio) {
          text 'Option 1'
        }
        menu_item(:separator)
        menu_item(:check) {
          text 'Option 3'
        }
      }
    }
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
}.open
