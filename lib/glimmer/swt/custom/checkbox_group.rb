require 'glimmer/ui/custom_widget'

module Glimmer
  module SWT
    module Custom
      # CodeText is a customization of StyledText with support for Ruby Syntax Highlighting
      class CheckboxGroup
        include Glimmer::UI::CustomWidget
        
        body {
          composite # just an empty composite to hold checkboxs upon data-binding `selection`
        }
        
        def items=(text_array)
          selection_value = selection
          @items = Array[*text_array]
          build_checkboxes
        end
        
        def items
          @items || []
        end
        
        def selection=(selection_texts)
          items.count.times do |index|
            checkbox = checkboxes[index]
            item = items[index]
            label_text = labels[index]&.text
            checkbox.selection = selection_texts.include?(label_text)
          end
        end
        
        def selection
          selection_indices.map do |selection_index|
            labels[selection_index]&.text
          end
        end
        
        def selection_indices=(indices)
          self.selection=(indices.to_a.map {|index| items[index]})
        end
        alias select selection_indices=
        
        def selection_indices
          checkboxes.select(&:selection).each_with_index.map do |selection_value, index|
            index
          end
        end
        
        def checkboxes
          @checkboxes ||= []
        end
        
        def labels
          @labels ||= []
        end
        
        def can_handle_observation_request?(observation_request)
          checkboxes.first&.can_handle_observation_request?(observation_request) || super(observation_request)
        end
        
        def handle_observation_request(observation_request, &block)
          observation_requests << [observation_request, block]
          delegate_observation_request_to_checkboxes(observation_request, &block)
          super
        end
        
        def delegate_observation_request_to_checkboxes(observation_request, &block)
          if observation_request != 'on_widget_disposed'
            checkboxes.count.times do |index|
              checkbox = checkboxes[index]
              label = labels[index]              
              if observation_request == 'on_widget_selected'
                checkbox_block = lambda do |event|
                  if event.widget.selection || selection_indices == -1
                    event.widget = self.swt_widget
                    block.call(event)
                  end
                end
                label_block = lambda do |event|
                  self.selection_indices = index
                  block.call(event)
                end              
                checkbox.handle_observation_request(observation_request, &checkbox_block) if checkbox.can_handle_observation_request?(observation_request)
                label.handle_observation_request('on_mouse_up', &label_block)
              else
                listener_block = lambda do |event|
                  event.widget = self.swt_widget
                  block.call(event)
                end
                checkbox.handle_observation_request(observation_request, &listener_block) if checkbox.can_handle_observation_request?(observation_request)
                label.handle_observation_request(observation_request, &listener_block) if label.can_handle_observation_request?(observation_request)              
              end
            end
          end
        end
        
        def observation_requests
          @observation_requests ||= Set.new
        end
        
        def has_attribute?(attribute_name, *args)
          (@composites.to_a + @checkboxes.to_a + @labels.to_a).map do |widget_proxy|
            return true if widget_proxy.has_attribute?(attribute_name, *args)            
          end
          super
        end
         
        def set_attribute(attribute_name, *args)
          excluded_attributes = ['selection']
          unless excluded_attributes.include?(attribute_name.to_s)
            (@composites.to_a + @checkboxes.to_a + @labels.to_a).each do |widget_proxy|
              widget_proxy.set_attribute(attribute_name, *args) if widget_proxy.has_attribute?(attribute_name, *args)
            end
          end
          super
        end
        
        private
        
        def build_checkboxes
          current_selection = selection
          @composites.to_a.each(&:dispose)
          @checkboxes = []
          @labels = []
          @composites = []
          items.each do |item|
            body_root.content {
              @composites << composite {
                grid_layout(2, false) {
                  margin_width 0
                  margin_height 0
                  horizontal_spacing 0
                  vertical_spacing 0
                }
                checkboxes << checkbox { |checkbox_proxy|
                  on_widget_selected {
                    self.selection = items[checkboxes.index(checkbox_proxy)]
                  }
                }
                labels << label { |label_proxy|
                  layout_data :fill, :center, true, false
                  text item
                  on_mouse_up {
                    self.selection = label_proxy.text
                  }
                }
              }
            }
          end
          observation_requests.to_a.each do |observation_request, block|
            delegate_observation_request_to_checkboxes(observation_request, &block)            
          end
          self.selection = current_selection
        end
      end
      
      CheckGroup = CheckboxGroup
    end
  end
end
