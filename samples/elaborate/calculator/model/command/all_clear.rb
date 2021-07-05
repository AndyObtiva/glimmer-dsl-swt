class Calculator
  module Model
    class Command
      class AllClear < Command
        keywords 'AC', 'c', 'C', 8.chr, 27.chr, 127.chr
  
        def execute
          self.result = '0'
          self.number1 = nil
          self.number2 = nil
          self.operation = nil
          command_history.clear
        end
      end
    end
  end
end
