include Glimmer

glimmer_logo = File.expand_path('../../images/glimmer-logo-hi-res.png', __dir__)

shell {
  text 'Hello, Canvas Transform!'
  minimum_size 330, 352
  
  canvas {
    background :white

    image(glimmer_logo, 0, 0) {
      transform {
        translate 110, 110
        rotate 90
        scale 0.21, 0.21
      }
    }
    image(glimmer_logo, 0, 0) {
      transform {
        translate 110, 220
        scale 0.21, 0.21
      }
    }
    image(glimmer_logo, 0, 0) {
      transform {
        translate 220, 220
        rotate 270
        scale 0.21, 0.21
      }
    }
    image(glimmer_logo, 0, 0) {
      transform {
        translate 220, 110
        rotate 180
        scale 0.21, 0.21
      }
    }
  }
}.open
