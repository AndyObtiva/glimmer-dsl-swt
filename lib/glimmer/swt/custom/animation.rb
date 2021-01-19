# Copyright (c) 2007-2021 Andy Maleh
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

require 'glimmer/swt/properties'

module Glimmer
  module SWT
    module Custom
      # Represents an animation declaratively
      class Animation
        include Properties # TODO rename to Properties
        
        attr_reader :parent, :options, :frame_index
        alias current_frame_index frame_index
        attr_accessor :frame_block, :every, :cycle, :cycle_count, :frame_count, :started
        # TODO consider supporting an async: false option
        
        def initialize(parent)
          @parent = parent
          @started = true
          @frame_index = 0
        end
        
        def post_add_content
          @parent.on_widget_disposed { stop }
          start if @started
        end
    
        def start
          swt_display = Glimmer::SWT::DisplayProxy.instance.swt_display
          return if swt_display.is_disposed?
          Thread.new do
            frame_rendering_block = lambda do
              block_args = [@frame_index]
              block_args << @cycle[@frame_index % @cycle.length] if @cycle.is_a?(Array)
              swt_display.async_exec do
                @parent.clear_shapes
                @parent.content {
                  frame_block.call(*block_args)
                }
              end
              @frame_index += 1
              sleep(every) if every.is_a?(Numeric)
            end
  
            if cycle_count.is_a?(Integer) && cycle.is_a?(Array)
              (cycle_count * cycle.length).times do
                break if break_condition?
                begin
                  frame_rendering_block.call
                rescue => e
                  Glimmer::Config.logger.error {e}
                  break
                end
              end
            else
              loop do
                break if break_condition?
                begin
                  frame_rendering_block.call
                rescue => e
                  Glimmer::Config.logger.error {e}
                  break
                end
              end
            end
            @started = false
          end
        end
        
        def stop
          @started = false
        end
        
        def has_attribute?(attribute_name, *args)
          respond_to?(ruby_attribute_setter(attribute_name)) && respond_to?(ruby_attribute_getter(attribute_name))
        end
  
        def set_attribute(attribute_name, *args)
          send(ruby_attribute_setter(attribute_name), *args)
        end
  
        def get_attribute(attribute_name)
          send(ruby_attribute_getter(attribute_name))
        end
        
        private
        
        def break_condition?
          !@started || (@frame_count.is_a?(Integer) && @frame_index == @frame_count)
        end
      end
      
    end
    
  end
  
end
