class GameOfLife
  module Model
    class Cell
      attr_reader :grid, :row_index, :column_index
      attr_accessor :alive
      alias alive? alive
    
      def initialize(grid, row_index, column_index)
        @grid = grid
        @row_index = row_index
        @column_index = column_index
      end
      
      def live!
        self.alive = true
      end
      
      def die!
        self.alive = false
      end
      
      def dead?
        !alive?
      end
    end
  end
end
