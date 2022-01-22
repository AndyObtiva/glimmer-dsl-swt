# Copyright (c) 2007-2022 Andy Maleh
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'glimmer/ui/custom_widget'

module Glimmer
  module SWT
    module Custom
      # A custom widget rendering a group of radios generated via data-binding
      class RadioGroup
        include Glimmer::UI::CustomWidget
        
        body {
          composite {} # just an empty composite to hold radios upon data-binding `selection`
        }
        
        def items=(text_array)
          selection_value = selection
          @items = Array[*text_array]
          build_radios
        end
        
        def items
          @items || []
        end
        alias get_items items
        
        def selection=(text)
          radios.count.times do |index|
            radio = radios[index]
            item = items[index]
            radio.selection = item == text
          end
        end
        
        def selection
          selection_value = labels[selection_index]&.text unless selection_index == -1
          selection_value.to_s
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
        
        def labels
          @labels ||= []
        end
        
        def can_handle_observation_request?(observation_request)
          radios.first&.can_handle_observation_request?(observation_request) or
            super(observation_request)
        end
        
        def handle_observation_request(observation_request, &block)
          observation_requests << [observation_request, block]
          delegate_observation_request_to_radios(observation_request, &block)
          super
        end
        
        def delegate_observation_request_to_radios(observation_request, &block)
          if observation_request != 'on_widget_disposed'
            radios.count.times do |index|
              radio = radios[index]
              label = labels[index]
              if observation_request == 'on_widget_selected'
                radio_block = lambda do |event|
                  if event.widget.selection || selection_index == -1
                    event.widget = self.swt_widget
                    block.call(event)
                  end
                end
                label_block = lambda do |event|
                  self.selection_index = index
                  block.call(event)
                end
                radio.handle_observation_request(observation_request, &radio_block) if radio.can_handle_observation_request?(observation_request)
                label.handle_observation_request('on_mouse_up', &label_block)
              else
                listener_block = lambda do |event|
                  event.widget = self.swt_widget
                  block.call(event)
                end
                radio.handle_observation_request(observation_request, &listener_block) if radio.can_handle_observation_request?(observation_request)
                label.handle_observation_request(observation_request, &listener_block) if label.can_handle_observation_request?(observation_request)
              end
            end
          end
        end
        
        def observation_requests
          @observation_requests ||= Set.new
        end
        
        def has_attribute?(attribute_name, *args)
          (@composites.to_a + @radios.to_a + @labels.to_a).map do |widget_proxy|
            return true if widget_proxy.has_attribute?(attribute_name, *args)
          end
          super
        end
         
        def set_attribute(attribute_name, *args)
          excluded_attributes = ['selection']
          unless excluded_attributes.include?(attribute_name.to_s)
            (@composites.to_a + @radios.to_a + @labels.to_a).each do |widget_proxy|
              widget_proxy.set_attribute(attribute_name, *args) if widget_proxy.has_attribute?(attribute_name, *args)
            end
          end
          super
        end
        
        private
        
        def build_radios
          current_selection = selection
          @composites.to_a.each(&:dispose)
          @radios = []
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
                radios << radio { |radio_proxy|
                  on_widget_selected {
                    self.selection = items[radios.index(radio_proxy)]
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
            delegate_observation_request_to_radios(observation_request, &block)
          end
          self.selection = current_selection
        end
      end
    end
  end
end
