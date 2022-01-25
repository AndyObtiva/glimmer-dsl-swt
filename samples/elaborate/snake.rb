require 'glimmer-dsl-swt'

require_relative 'snake/presenter/grid'

class Snake
  include Glimmer::UI::CustomShell
  
  CELL_SIZE = 15
  SNAKE_MOVE_DELAY = 100 # millis
  
  before_body do
    @game = Model::Game.new
    @grid = Presenter::Grid.new(@game)
    @game.start
    @keypress_queue = []
    
    display {
      on_swt_keydown do |key_event|
        if key_event.keyCode == 32
          @game.toggle_pause
        else
          @keypress_queue << key_event.keyCode
        end
      end
    }
  end
  
  after_body do
    register_observers
  end
  
  body {
    shell(:no_resize) {
      grid_layout(@game.width, true) {
        margin_width 0
        margin_height 0
        horizontal_spacing 0
        vertical_spacing 0
      }
    
      # data-bind window title to game score, converting it to a title string on read from the model
      text <= [@game, :score, on_read: -> (score) {"Snake (Score: #{@game.score})"}]
      minimum_size @game.width * CELL_SIZE, @game.height * CELL_SIZE
      
      @game.height.times do |row|
        @game.width.times do |column|
          canvas {
            layout_data {
              width_hint CELL_SIZE
              height_hint CELL_SIZE
            }
            
            rectangle(0, 0, CELL_SIZE, CELL_SIZE) {
              background <= [@grid.cells[row][column], :color] # data-bind square fill to grid cell color
            }
          }
        end
      end
    }
  }
  
  def register_observers
    observe(@game, :over) do |game_over|
      async_exec do
        if game_over
          message_box {
            text 'Game Over!'
            message "Score: #{@game.score} | High Score: #{@game.high_score}"
          }.open
          @game.start
        end
      end
    end
    
    timer_exec(SNAKE_MOVE_DELAY, &method(:move_snake))
  end
  
  def move_snake
    unless @game.paused? || @game.over?
      process_queued_keypress
      @game.snake.move
    end
    timer_exec(SNAKE_MOVE_DELAY, &method(:move_snake))
  end
  
  def process_queued_keypress
    # key press queue ensures one turn per snake move to avoid a double-turn resulting in instant death (due to snake illogically going back against itself)
    key = @keypress_queue.shift
    if [@game.snake.head.orientation, key] == [:north, swt(:arrow_right)] ||
       [@game.snake.head.orientation, key] == [:east, swt(:arrow_down)] ||
       [@game.snake.head.orientation, key] == [:south, swt(:arrow_left)] ||
       [@game.snake.head.orientation, key] == [:west, swt(:arrow_up)]
      @game.snake.turn_right
    elsif [@game.snake.head.orientation, key] == [:north, swt(:arrow_left)] ||
          [@game.snake.head.orientation, key] == [:west, swt(:arrow_down)] ||
          [@game.snake.head.orientation, key] == [:south, swt(:arrow_right)] ||
          [@game.snake.head.orientation, key] == [:east, swt(:arrow_up)]
      @game.snake.turn_left
    end
  end
end

Snake.launch
