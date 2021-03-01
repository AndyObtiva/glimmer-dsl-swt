require 'glimmer-dsl-swt'
        
include Glimmer
  
shell {
  text 'Hello, Canvas Path!'
  minimum_size 800, 700
  background :white
  
    canvas {
      background :white
      
      text('line', 15, 200) {
        foreground :red
      }
      @path1 = path {
        antialias :on
        foreground :red
      }
      
      text('quad', 15, 300) {
        foreground :dark_green
      }
      @path2 = path {
        antialias :on
        foreground :dark_green
      }
      
      text('cubic', 15, 400) {
        foreground :blue
      }
      @path3 = path {
        antialias :on
        foreground :blue
      }
    }
  
  on_swt_show {
    Thread.new {
      y1 = y2 = y3 = 300
      800.times.each do |x|
        x += 55
        x1 = x - 2
        x2 = x - 1
        x3 = x
        y1 = y3
        y2 = y1
        y3 = [[y3 + (rand*24 - 12), 0].max, 700].min
        @path1.content {
          line(x1, y1 - 100)
        }
        if x % 2 == 0
          @path2.content {
            quad(x1, y1, x2, y2)
          }
        end
        if x % 3 == 0
          @path3.content {
            cubic(x1, y1 + 100, x2, y2 + 100, x3, y3 + 100)
          }
        end
        sleep(0.01)
      end
    }
  }
}.open
