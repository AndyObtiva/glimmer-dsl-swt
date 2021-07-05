class Calculator
  module Model
    class Command
      class Operation < Command
        def execute
          if number1 && number2 && operation && !last_command.is_a?(Equals)
            self.result = operation.calculate.to_s
            self.number1 = self.result
          else
            self.result = last_result || '0'
            self.operation = self
          end
        end
        
        def calculate
          calculation_result = BigDecimal.new(number1.to_s).send(operation_method, BigDecimal.new(number2.to_s)).to_f
          calculation_result.to_s.match(/\.0+$/) ? calculation_result.to_i : calculation_result
        end
        
        # Subclasses must implement to indicate operation method on number (e.g. :+ for addition)
        def operation_method
          raise 'Not implemented!'
        end
      end
    end
  end
end
