include Glimmer

shell {
  text 'Hello, Canvas!'
  minimum_size 320, 400

  canvas {
    background :yellow
    rectangle(0, 0, 220, 400, fill: true) {
      background :red
    }
    rectangle(50, 20, 300, 150, 30, 50, fill: true, round: true) {
      background :magenta
    }
    rectangle(150, 200, 100, 70, true, fill: true, gradient: true) {
      background :dark_magenta
      foreground :yellow
    }
    rectangle(50, 200, 30, 70, false, fill: true, gradient: true) {
      background :magenta
      foreground :dark_blue
    }
    rectangle(205, 50, 88, 96) {
      foreground :yellow
    }
    text('Picasso', 60, 80) {
      background :yellow
      foreground :dark_magenta
      font name: 'Courier', height: 30
    }
    oval(110, 310, 100, 100, fill: true) {
      background rgb(128, 138, 248)
    }
    arc(210, 210, 100, 100, 30, -77, fill: true) {
      background :red
    }
    polygon(250, 210, 260, 170, 270, 210, 290, 230, 250, 210, fill: true) {
      background :dark_yellow
      foreground :yellow
    }
    polygon(250, 110, 260, 70, 270, 110, 290, 130, 250, 110)
  }
}.open
