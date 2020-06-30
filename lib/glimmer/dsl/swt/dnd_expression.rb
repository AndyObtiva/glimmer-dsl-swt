require 'glimmer/dsl/static_expression'
require 'glimmer/swt/dnd_proxy'

# TODO consider turning static keywords like bind into methods

module Glimmer
  module DSL
    module SWT
      # Responsible for returning DND constant values
      #
      # Named DndExpression (not DNDExpression) so that the DSL engine
      # discovers quickly by convention
      class DndExpression < StaticExpression
        def can_interpret?(parent, keyword, *args, &block)
          block.nil? &&
            args.size > 0
        end
  
        def interpret(parent, keyword, *args, &block)
          Glimmer::SWT::DNDProxy[*args]
        end
      end
    end
  end
end
