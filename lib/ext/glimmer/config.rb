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

require 'glimmer/config'

module Glimmer
  module Config
    DEFAULT_IMPORT_SWT_PACKAGES = [
      'org.eclipse.swt',
      'org.eclipse.swt.widgets',
      'org.eclipse.swt.layout',
      'org.eclipse.swt.graphics',
      'org.eclipse.swt.browser',
      'org.eclipse.swt.custom',
      'org.eclipse.swt.dnd',
      'org.eclipse.swt.printing',
    ]
    DEFAULT_AUTO_SYNC_EXEC = true
    
    class << self
      # Tells Glimmer to import SWT packages into including class (default: true)
      def import_swt_packages=(value)
        @@import_swt_packages = value
      end
  
      # Returns whether Glimmer will import SWT packages into including class
      def import_swt_packages
        @@import_swt_packages = DEFAULT_IMPORT_SWT_PACKAGES if !defined?(@@import_swt_packages) || (defined?(@@import_swt_packages) && @@import_swt_packages == true)
        @@import_swt_packages
      end
      
      # Tells Glimmer to avoid automatic use of sync_exec when invoking GUI calls from another thread (default: true)
      def auto_sync_exec=(value)
        @@auto_sync_exec = value
      end
  
      # Returns whether Glimmer will import SWT packages into including class
      def auto_sync_exec
        @@auto_sync_exec = DEFAULT_AUTO_SYNC_EXEC if !defined?(@@auto_sync_exec)
        @@auto_sync_exec
      end
      alias auto_sync_exec? auto_sync_exec
      
      # allowed logger types are :logger (default) and :logging (logging gem supporting async logging)
      # updating logger type value resets logger
      def logger_type=(logger_type_class)
        @@logger_type = logger_type_class
        reset_logger!
      end
      
      def logger_type
        unless defined? @@logger_type
          @@logger_type = :logger
        end
        @@logger_type
      end
      
      # Returns Logging Devices. Default is [:stdout, :syslog]
      def logging_devices
        unless defined? @@logging_devices
          @@logging_devices = [:stdout, :syslog]
        end
        @@logging_devices
      end
      
      # Logging Devices is an array of these possible values: :stdout (default), :stderr, :file, :syslog (default), :stringio
      def logging_devices=(devices)
        @@logging_devices = devices
        reset_logger!
      end
      
      def logging_device_file_options
        @@logging_device_file_options = {size: 1_000_000, age: 'daily', roll_by: 'number'} unless defined? @@logging_device_file_options
        @@logging_device_file_options
      end
      
      def logging_device_file_options=(custom_options)
        @@logging_device_file_options = custom_options
        reset_logger!
      end
      
      def logging_appender_options
        @@logging_appender_options = {async: true, auto_flushing: 500, write_size: 500, flush_period: 60, immediate_at: [:error, :fatal], layout: logging_layout} unless defined? @@logging_appender_options
        # TODO make this a glimmer command option
        if ENV['GLIMMER_LOGGER_ASYNC'].to_s.downcase == 'false'
          @@logging_appender_options.merge!(async: false, auto_flushing: 1, immediate_at: [:debug, :info, :warn, :error, :fatal])
        end
        @@logging_appender_options
      end
      
      def logging_appender_options=(custom_options)
        @@logging_appender_options = custom_options
        reset_logger!
      end
      
      def logging_layout
        unless defined? @@logging_layout
          @@logging_layout = Logging.layouts.pattern(
            pattern: '[%d] %-5l %c: %m\n',
            date_pattern: '%Y-%m-%d %H:%M:%S'
          )
        end
        @@logging_layout
      end
      
      def logging_layout=(custom_layout)
        @@logging_layout = custom_layout
        reset_logger!
      end
      
      alias reset_logger_without_glimmer_dsl_swt! reset_logger!
      def reset_logger!
        if logger_type == :logger
          reset_logger_without_glimmer_dsl_swt!
        else
          require 'logging'
          @first_time = !defined?(@@logger)
          old_level = logger.level unless @first_time
          self.logger = Logging.logger['glimmer'].tap do |logger|
            logger.level = old_level || :error
            appenders = []
            appenders << Logging.appenders.stdout(logging_appender_options) if logging_devices.include?(:stdout)
            appenders << Logging.appenders.stderr(logging_appender_options) if logging_devices.include?(:stderr)
            if logging_devices.include?(:file)
              require 'fileutils'
              FileUtils.mkdir_p('log')
              appenders << Logging.appenders.rolling_file('log/glimmer.log', logging_appender_options.merge(logging_device_file_options)) if logging_devices.include?(:file)
            end
            if Object.const_defined?(:Syslog) && logging_devices.include?(:syslog)
              Syslog.close if Syslog.opened?
              appenders << Logging.appenders.syslog('glimmer', logging_appender_options)
            end
            logger.appenders = appenders
          end
        end
      end
    end
  end
end

if ENV['GLIMMER_LOGGER_LEVEL']
  if Glimmer::Config.logger_type == :logging
    # if glimmer log level is being overridden for debugging purposes, then disable async logging making logging immediate
    Glimmer::Config.logging_appender_options = Glimmer::Config.logging_appender_options.merge(async: false, auto_flushing: 1, immediate_at: [:unknown, :debug, :info, :error, :fatal])
    Glimmer::Config.logging_devices = [:stdout]
  end
  begin
    puts "Adjusting Glimmer logging level to #{ENV['GLIMMER_LOGGER_LEVEL']}"
    Glimmer::Config.logger.level = ENV['GLIMMER_LOGGER_LEVEL'].strip
  rescue => e
    puts e.message
  end
end

Glimmer::Config.excluded_keyword_checkers << lambda do |method_symbol, *args|
  method = method_symbol.to_s
  return true if method == 'post_initialize_child'
  return true if method == 'handle'
  return true if method.end_with?('=')
  return true if ['drag_source_proxy', 'drop_target_proxy'].include?(method) && is_a?(Glimmer::UI::CustomWidget)
  return true if method == 'dispose' && is_a?(Glimmer::UI::CustomWidget) && respond_to?(method)
  return true if ['finish_edit!', 'search', 'all_tree_items', 'depth_first_search'].include?(method) && is_a?(Glimmer::UI::CustomWidget) && body_root.respond_to?(method)
end
