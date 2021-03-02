# Copyright (c) 2007-2021 Andy Maleh
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'glimmer-dsl-swt'

# This Sample is an Early Alpha (New Canvas Path DSL Feature)

class StockTicker
  class Stock
    class << self
      attr_writer :price_min, :price_max
      
      def price_min
        @price_min ||= 1
      end
      
      def price_max
        @price_max ||= 600
      end
    end
    
    attr_reader :name, :prices
    attr_accessor :price
    
    def initialize(name, price)
      @name = name
      @price = price
      @prices = [@price]
      @delta_sign = 1
      start_new_trend!
    end
    
    def tick!
      @tick_count = @tick_count.to_i + 1
      delta = @tick_count%@trend_length
      if delta == 0
        @delta_sign *= -1
        start_new_trend!
      end
      prices << self.price = [[@price + @delta_sign*delta, Stock.price_min].max, Stock.price_max].min
    end
    
    def start_new_trend!
      @trend_length = (rand*12).to_i + 1
    end
  end
  
  include Glimmer::UI::CustomShell
  
  before_body {
    @stocks = [
      Stock.new('DELL', 81),
      Stock.new('AAPL', 121),
      Stock.new('MSFT', 232),
      Stock.new('ADBE', 459),
    ]
    @stock_colors = [:red, :dark_green, :blue, :dark_magenta]
    margin = 5
    @tabs = ['Lines', 'Quadratic Bezier Curves', 'Cubic Bezier Curves', 'Points'].map {|title| {title: title, stock_paths: []}}
    @stocks.each_with_index do |stock, stock_index|
      observe(stock, :price) do |new_price|
        begin
          @tabs.each do |tab|
            new_x = stock.prices.count - 1
            new_y = @tabs.first[:canvas].bounds.height - new_price - 1
            if new_x > 0
              case tab[:title]
              when 'Cubic Bezier Curves'
                if new_x%3 == 0 && stock.prices[new_x] && stock.prices[new_x - 1] && stock.prices[new_x - 2]
                  tab[:stock_paths][stock_index].content {
                    cubic(new_x - 2 + margin, @tabs.first[:canvas].bounds.height - stock.prices[new_x - 2] - 1, new_x - 1 + margin, @tabs.first[:canvas].bounds.height - stock.prices[new_x - 1] - 1, new_x + margin, new_y)
                  }
                end
              when 'Quadratic Bezier Curves'
                if new_x%2 == 0 && stock.prices[new_x] && stock.prices[new_x - 1]
                  tab[:stock_paths][stock_index].content {
                    quad(new_x - 1 + margin, @tabs.first[:canvas].bounds.height - stock.prices[new_x - 1] - 1, new_x + margin, new_y)
                  }
                end
              when 'Lines'
                tab[:stock_paths][stock_index].content {
                  line(new_x + margin, new_y)
                }
              when 'Points'
                tab[:stock_paths][stock_index].content {
                  point(new_x + margin, new_y)
                }
              end
              new_x_location = new_x + 2*margin
              canvas_width = tab[:canvas].bounds.width
              if new_x_location > canvas_width
                tab[:canvas].set_size(new_x_location, @tabs.first[:canvas].bounds.height)
                tab[:canvas].cursor = :hand
                tab[:scrolled_composite].set_min_size(new_x_location, @tabs.first[:canvas].bounds.height)
                tab[:scrolled_composite].set_origin(tab[:scrolled_composite].origin.x + 1, tab[:scrolled_composite].origin.y) if (tab[:scrolled_composite].origin.x + tab[:scrolled_composite].client_area.width) == canvas_width
              end
            else
              tab[:canvas_header].content {
                text(stock.name, 15, new_y - 10) {
                  foreground @stock_colors[stock_index]
                  font height: 14
                }
              }
            end
          end
        rescue => e
          Glimmer::Config.logger.error {e.full_message}
        end
      end
    end
  }
  
  after_body {
    @thread = Thread.new {
      loop {
        @stocks.each(&:tick!)
        sleep(0.01)
      }
    }
  }
  
  body {
    shell {
      fill_layout {
        margin_width 15
        margin_height 15
      }
      text 'Stock Ticker'
      minimum_size 650, 650
      background :white
      
      @tab_folder = tab_folder {
        @tabs.each do |tab|
          tab_item {
            grid_layout(2, false) {
              margin_width 0
              margin_height 0
            }
            text tab[:title]
            
            tab[:canvas_header] = canvas {
              layout_data(:center, :fill, false, true)
            }
            tab[:scrolled_composite] = scrolled_composite {
              layout_data :fill, :fill, true, true
              tab[:canvas] = canvas {
                background :white
                
                @stocks.count.times do |stock_index|
                  tab[:stock_paths][stock_index] = path {
                    antialias :on
                    foreground @stock_colors[stock_index]
                  }
                end
                
                on_mouse_down {
                  @drag_detected = false
                }
                
                on_drag_detected { |drag_detect_event|
                  @drag_detected = true
                  @drag_start_x = drag_detect_event.x
                  @drag_start_y = drag_detect_event.y
                }
                
                on_mouse_move { |mouse_event|
                  if @drag_detected
                    origin = tab[:scrolled_composite].origin
                    new_x = origin.x - (mouse_event.x - @drag_start_x)
                    new_y = origin.y - (mouse_event.y - @drag_start_y)
                    tab[:scrolled_composite].set_origin(new_x, new_y)
                  end
                }
                
                on_mouse_up { |mouse_event|
                  @drag_detected = false
                }
              }
            }
          }
        end
      }
    
      on_swt_show {
        Stock.price_min = 25
        Stock.price_max = @tabs.first[:canvas].bounds.height - 6
      }
      
      on_widget_disposed {
        @thread.kill # safe to kill as data is in memory only
      }
    }
  }
end

StockTicker.launch
        
