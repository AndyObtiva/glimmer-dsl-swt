class Calculator
  module Model
    class Command
      class Operation < Command
        class Add < Operation
          keyword '+'
          
          def operation_method
            :+
          end
        end
      end
    end
  end
end
