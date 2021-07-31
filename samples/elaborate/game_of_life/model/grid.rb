require_relative 'cell'

class GameOfLife
  module Model
    class Grid
      DEFAULT_ROW_COUNT = 100
      DEFAULT_COLUMN_COUNT = 100
      
      attr_reader :row_count, :column_count
      attr_accessor :cell_rows, :previous_cell_rows
    
      def initialize(row_count=DEFAULT_ROW_COUNT, column_count=DEFAULT_COLUMN_COUNT)
        @row_count = row_count
        @column_count = column_count
        build_cells
      end
      
      # steps into the next generation of cells given their current neighbors
      def step!
        self.previous_cell_rows = cell_rows.map do |row|
          row.map do |cell|
            cell.clone
          end
        end
        cell_rows.each do |row|
          row.each do |cell|
            cell.step!
          end
        end
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
