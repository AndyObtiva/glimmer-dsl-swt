require 'glimmer-dsl-swt'

include Glimmer

glimmer_logo = File.expand_path('../../icons/scaffold_app.png', __dir__)

shell {
  text 'Hello, Canvas Transform!'
  minimum_size (OS.windows? ? 347 : 330), (OS.windows? ? 372 : 352)
  
  canvas {
    background :white

    image(glimmer_logo, 0, 0) {
      transform {
        translation 110, 110
        rotation 90
        scale 0.21, 0.21
        # also supports inversion, identity, shear, and multiplication {transform properties}
      }
    }
    image(glimmer_logo, 0, 0) {
      transform {
        translation 110, 220
        scale 0.21, 0.21
      }
    }
    image(glimmer_logo, 0, 0) {
      transform {
        translation 220, 220
        rotation 270
        scale 0.21, 0.21
      }
    }
    image(glimmer_logo, 0, 0) {
      transform {
        translation 220, 110
        rotation 180
        scale 0.21, 0.21
      }
    }
  }
}.open
