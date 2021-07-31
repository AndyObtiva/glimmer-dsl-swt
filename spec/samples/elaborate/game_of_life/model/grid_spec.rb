require 'spec_helper'

require File.join(ROOT_PATH, 'samples/elaborate/game_of_life/model/grid')

class GameOfLife
  module Model
    describe Grid do
      describe '#new' do
        let(:row_count_default) {100}
        let(:column_count_default) {100}
        let(:row_count) {20}
        let(:column_count) {10}
      
        it 'constructs a grid of 100x100 cells by default' do
          grid = described_class.new
          
          expect(grid.cell_rows.count).to eq(row_count_default)
                    
          row_count_default.times do |row_index|
            row = grid.cell_rows[row_index]
            
            expect(row).to be_a(Array)
            expect(row.count).to eq(column_count_default)
          
            column_count_default.times do |column_index|
              cell = row[column_index]
              
              expect(cell).to be_a(Cell)
              expect(cell.row_index).to eq(row_index)
              expect(cell.column_index).to eq(column_index)
              expect(cell.grid).to eq(grid)
            end
          end
        end
        
        it 'constructs a grid of 20x10 cells by arguments' do
          grid = described_class.new(row_count, column_count)
          
          expect(grid.cell_rows.count).to eq(row_count)
                    
          row_count.times do |row_index|
            row = grid.cell_rows[row_index]
            
            expect(row).to be_a(Array)
            expect(row.count).to eq(column_count)
          
            column_count.times do |column_index|
              cell = row[column_index]
              
              expect(cell).to be_a(Cell)
              expect(cell.row_index).to eq(row_index)
              expect(cell.column_index).to eq(column_index)
              expect(cell.grid).to eq(grid)
            end
          end
        end
      end
      
      describe '#live!' do
        it 'makes a dead cell alive' do
          cell = subject.cell_rows[0][0]
          
          expect(cell.alive?).to be_falsey
          expect(cell.dead?).to be_truthy
          
          cell.live!
          
          expect(cell.alive?).to be_truthy
          expect(cell.dead?).to be_falsey
        end
      end
      
      describe '#die!' do
        it 'makes a live cell dead' do
          cell = subject.cell_rows[0][0]
          cell.live!
          
          expect(cell.alive?).to be_truthy
          expect(cell.dead?).to be_falsey
          
          cell.die!
          
          expect(cell.alive?).to be_falsey
          expect(cell.dead?).to be_truthy
        end
      end
    end
  end
end
