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
require 'glimmer/swt/custom/shape'

module Glimmer
  module SWT
    module Custom
      # Represents an animation declaratively
      class Animation
        include Properties
        include Glimmer::DataBinding::ObservableModel
        
        class << self
          def schedule_frame_animation(animation, &frame_animation_block)
            frame_animation_queue(animation).prepend(frame_animation_block)
            swt_display.async_exec do
              frame_animation_queue(next_animation)&.pop&.call
            end
          end
          
          def next_animation
            animation = nil
            while frame_animation_queues.values.reduce(:+)&.any? && (animation.nil? || frame_animation_queue(animation).last.nil?)
              animation = frame_animation_queues.keys[next_animation_index]
              frame_animation_queues.delete(animation) if frame_animation_queues.values.reduce(:+)&.any? && !animation.nil? && frame_animation_queue(animation).empty?
            end
            animation
          end
          
          def next_animation_index
            next_schedule_index % frame_animation_queues.keys.size
          end
          
          def next_schedule_index
            unless defined? @@next_schedule_index
              @@next_schedule_index = 0
            else
              @@next_schedule_index += 1
            end
          end
          
          def frame_animation_queues
            unless defined? @@frame_animation_queues
              @@frame_animation_queues = {}
            end
            @@frame_animation_queues
          end
          
          def frame_animation_queue(animation)
            frame_animation_queues[animation] ||= []
          end
          
          def swt_display
            unless defined? @@swt_display
              @@swt_display = DisplayProxy.instance.swt_display
            end
            @@swt_display
          end
        end
        
        attr_reader :parent, :options
        attr_accessor :frame_index, :cycle, :frame_block, :every, :cycle_count, :frame_count, :started, :duration_limit, :duration, :finished, :cycle_count_index
        alias current_frame_index frame_index
        alias started? started
        alias finished? finished
        # TODO consider supporting an async: false option
        
        def initialize(parent)
          @parent = parent
          @parent.requires_shape_disposal = true
          self.started = true
          self.frame_index = 0
          self.cycle_count_index = 0
          @start_number = 0 # denotes the number of starts (increments on every start)
          self.class.swt_display # ensures initializing variable to set from GUI thread
        end
        
        def post_add_content
          if @dispose_listener_registration.nil?
            @dispose_listener_registration = @parent.on_widget_disposed { stop }
            start if started?
          end
        end
        
        def content(&block)
          Glimmer::SWT::DisplayProxy.instance.auto_exec do
            Glimmer::DSL::Engine.add_content(self, Glimmer::DSL::SWT::AnimationExpression.new, 'animation', &block)
          end
        end
                
        # Starts an animation that is indefinite or has never been started before (i.e. having `started: false` option).
        # Otherwise, resumes a stopped animation that has not been completed.
        def start
          return if @start_number > 0 && started?
          @start_number += 1
          @start_time = Time.now
          @duration = 0
          @original_start_time = @start_time if @duration.nil?
          self.finished = false if finished?
          self.started = true
          # TODO track when finished in a variable for finite animations (whether by frame count, cycle count, or duration limit)
          Thread.new do
            start_number = @start_number
            if cycle_count.is_a?(Integer) && cycle.is_a?(Array)
              (cycle_count * cycle.length).times do
                break unless draw_frame(start_number)
              end
            else
              loop do
                # this code has to be duplicated to break from a loop (break keyword only works when literally in a loop block)
                break unless draw_frame(start_number)
              end
            end
          end
        end
        
        def stop
          return if stopped?
          self.started = false
          self.duration = (Time.now - @start_time) + @duration.to_f if duration_limited? && !@start_time.nil?
        end
        
        # Restarts an animation (whether indefinite or not and whether stopped or not)
        def restart
          @original_start_time = @start_time = Time.now
          self.duration = 0
          self.frame_index = 0
          self.cycle_count_index = 0
          stop
          start
        end
        
        def stopped?
          !started?
        end
        
        def finite?
          frame_count_limited? || cycle_limited? || duration_limited?
        end
        
        def infinite?
          !finite?
        end
        alias indefinite? infinite?
        
        def has_attribute?(attribute_name, *args)
          respond_to?(ruby_attribute_setter(attribute_name)) && respond_to?(ruby_attribute_getter(attribute_name))
        end
  
        def set_attribute(attribute_name, *args)
          send(ruby_attribute_setter(attribute_name), *args)
        end
  
        def get_attribute(attribute_name)
          send(ruby_attribute_getter(attribute_name))
        end
        
        def cycle=(*args)
          if args.size == 1
            if args.first.is_a?(Array)
              @cycle = args.first
            else
              @cycle = [args.first]
            end
          elsif args.size > 1
            @cycle = args
          end
        end
        
        def cycle_count_index=(value)
          @cycle_count_index = value
          self.finished = true if cycle_limited? && @cycle_count_index == @cycle_count
          @cycle_count_index
        end
        
        def frame_index=(value)
          @frame_index = value
          self.finished = true if frame_count_limited? && @frame_index == @frame_count
          @frame_index
        end
        
        def duration=(value)
          @duration = value
          self.finished = true if surpassed_duration_limit?
          @duration
        end
        
        def cycle_enabled?
          @cycle.is_a?(Array)
        end
        
        def cycle_limited?
          cycle_enabled? && @cycle_count.is_a?(Integer)
        end
        
        def duration_limited?
          @duration_limit.is_a?(Numeric) && @duration_limit > 0
        end
        
        def frame_count_limited?
          @frame_count.is_a?(Integer) && @frame_count > 0
        end
        
        def surpassed_duration_limit?
          duration_limited? && ((Time.now - @start_time) > @duration_limit)
        end
        
        def within_duration_limit?
          !surpassed_duration_limit?
        end
        
        private
        
        # Returns true on success of painting a frame and false otherwise
        def draw_frame(start_number)
          if stopped? or
              (start_number != @start_number) or
              (frame_count_limited? && @frame_index == @frame_count) or
              (cycle_limited? && @cycle_count_index == @cycle_count) or
              surpassed_duration_limit?
            self.duration = Time.now - @start_time
            return false
          end
          block_args = [@frame_index]
          block_args << @cycle[@frame_index % @cycle.length] if cycle_enabled?
          current_frame_index = @frame_index
          current_cycle_count_index = @cycle_count_index
          self.class.schedule_frame_animation(self) do
            self.duration = Time.now - @start_time # TODO should this be set here, after the if statement, in the else too, or outside both?
            if started? && start_number == @start_number && within_duration_limit?
              unless @parent.isDisposed
                @shapes.to_a.each(&:dispose)
                parent_shapes_before = @parent.shapes.clone
                @parent.content {
                  frame_block.call(*block_args)
                }
                @shapes = @parent.shapes - parent_shapes_before
                self.duration = Time.now - @start_time # TODO consider if this is needed
              end
            else
              if stopped? && @frame_index > current_frame_index
                self.frame_index = current_frame_index
                self.cycle_count_index = current_cycle_count_index
              end
            end
          end
          self.frame_index += 1
          self.cycle_count_index += 1 if cycle_limited? && (@frame_index % @cycle&.length&.to_i) == 0
          sleep(every) if every.is_a?(Numeric) # TODO consider using timer_exec as a perhaps more reliable alternative
          true
        rescue => e
          Glimmer::Config.logger.error {e}
          false
        end
        
      end
      
    end
    
  end
  
end
