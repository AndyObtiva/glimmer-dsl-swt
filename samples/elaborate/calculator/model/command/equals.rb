class Calculator
  module Model
    class Command
      class Equals < Command
        keywords '=', "\r"

        def execute
          if number1 && number2 && operation
            self.result = operation.calculate.to_s
            self.number1 = self.result
          else
            self.result = last_result || '0'
          end
        end
      end
    end
  end
end
