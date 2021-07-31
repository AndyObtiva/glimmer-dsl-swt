require_relative 'cell'

class GameOfLife
  module Model
    class Grid
      DEFAULT_ROW_COUNT = 100
      DEFAULT_COLUMN_COUNT = 100
      
      attr_reader :row_count, :column_count, :cell_rows
    
      def initialize(row_count=DEFAULT_ROW_COUNT, column_count=DEFAULT_COLUMN_COUNT)
        @row_count = row_count
        @column_count = column_count
        build_cells
      end
      
      private
      
      def build_cells
        @cell_rows = @row_count.times.map do |row_index|
          @column_count.times.map do |column_index|
            Cell.new(self, row_index, column_index)
          end
        end
      end
    end
  end
end
