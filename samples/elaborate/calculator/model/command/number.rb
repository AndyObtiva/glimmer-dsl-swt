class Calculator
  module Model
    class Command
      class Number < Command
        keywords ('0'..'9').to_a
              
        def execute
          self.result = last_result.nil? || (!last_command.is_a?(Number) && !last_command.is_a?(Point)) ? button : last_result + button
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
