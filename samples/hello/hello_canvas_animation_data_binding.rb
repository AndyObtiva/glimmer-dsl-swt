require 'glimmer-dsl-swt'
require 'bigdecimal'

class HelloAnimationDataBinding
  include Glimmer::UI::CustomShell
  
  attr_accessor :delay_time
  
  before_body {
    @delay_time = 0.050
  }
  
  body {
    shell {
      text 'Hello, Canvas Animation Data Binding'
      minimum_size 320, 320
      
      canvas {
        grid_layout
        
        spinner {
          layout_data(:center, :center, true, true) {
            minimum_width 75
          }
          digits 3
          minimum 1
          maximum 100
          selection bind(self, :delay_time, on_read: ->(v) {(BigDecimal(v.to_s)*1000).to_f}, on_write: ->(v) {(BigDecimal(v.to_s)/1000).to_f})
        }
        animation {
          every bind(self, :delay_time)
          
          frame { |index|
            background rgb(index%100, index%100 + 100, index%55 + 200)
            oval(index*3%300, index*3%300, 20, 20) {
              background :yellow
            }
          }
        }
      }
    }
  }
end

HelloAnimationDataBinding.launch
