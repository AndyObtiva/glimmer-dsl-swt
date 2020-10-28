require 'glimmer/ui/custom_widget'

module Glimmer
  module SWT
    module Custom
      # CodeText is a customization of StyledText with support for Ruby Syntax Highlighting
      class RadioGroup
        include Glimmer::UI::CustomWidget
        
        # TODO support setting font, background, foreground, cursor
        
        body {
          composite # just an empty composite to hold radios upon data-binding `selection`
        }
        
        def items=(text_array)
          selection_value = selection
          @items = Array[*text_array]
          build_radios
        end
        
        def items
          @items
        end
        
        def selection=(text)
          radios.each do |radio|
            radio.selection = radio.text == text
          end
        end
        
        def selection
          # TODO use labels to retrieve text since they are better customizable with fonts while maintaining alignment with radio buttons
          radios.detect(&:selection)&.text.to_s
        end
        
        def selection_index=(index)
          self.selection=(items[index])
        end
        alias select selection_index=
        
        def selection_index
          radios.index(radios.detect(&:selection)) || -1
        end
        
        def radios
          @radios ||= []
        end
        
        def can_handle_observation_request?(observation_request)
          radios.first&.can_handle_observation_request?(observation_request) || super(observation_request)
        end
        
        def handle_observation_request(observation_request, &block)
          observation_requests << [observation_request, block]
          delegate_observation_request_to_radios(observation_request, &block)
          super
        end
        
        def delegate_observation_request_to_radios(observation_request, &block)
          if observation_request != 'on_widget_disposed' && radios.first&.can_handle_observation_request?(observation_request)
            radios.each do |radio|            
              radio_block = lambda do |event|
                if event.widget.selection || selection_index == -1
                  event.widget = self.swt_widget
                  block.call(event)
                end
              end
              radio.handle_observation_request(observation_request, &block)
            end
          end
        end
        
        def observation_requests
          @observation_requests ||= Set.new
        end
        
        private
        
        def build_radios
          # TODO consider doing a diff instead of disposing and rebuilding everything in the future
          # TODO add labels since they are better customizable with fonts while maintaining alignment with radio buttons
          current_selection = selection
          radios.each(&:dispose) # TODO take care of the fact that dispose removes the observers attached
          @radios = []
          items.each do |item|
            body_root.content {
              radios << radio {
                text item
              }
            }
          end
          observation_requests.to_a.each do |observation_request, block|
            delegate_observation_request_to_radios(observation_request, &block)            
          end
          self.selection = current_selection
        end
      end
    end
  end
end
