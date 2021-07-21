class Calculator
  module Model
    class Command
      class Point < Command
        keyword '.'

        def execute
          self.result = last_result.nil? || !last_command.is_a?(Number) ? '0.' : "#{last_result}."
          if operation.nil? || last_command.is_a?(Equals)
            self.number1 = self.result
            self.number2 = nil
            self.operation = nil
          else
            self.number2 = self.result
          end
        end
      end
    end
  end
end
