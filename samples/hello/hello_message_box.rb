include Glimmer

@shell = shell {
  text 'Hello, Message Box!'
  button {
    text 'Please Click To Win a Surprise'
    on_widget_selected {
      message_box(@shell) {
        text 'Surprise'
        message "Congratulations!\n\nYou have won $1,000,000!"
      }.open
    }
  }
}
@shell.open
