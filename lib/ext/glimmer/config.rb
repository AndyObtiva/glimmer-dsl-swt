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
    ]
    
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
      
      def reset_logger!
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

Glimmer::Config.reset_logger! unless ENV['GLIMMER_LOGGER_ENABLED'].to_s.downcase == 'false'
if ENV['GLIMMER_LOGGER_LEVEL']
  # if glimmer log level is being overridden for debugging purposes, then disable async logging making logging immediate
  Glimmer::Config.logging_appender_options = Glimmer::Config.logging_appender_options.merge(async: false, auto_flushing: 1)
  Glimmer::Config.logging_devices = [:stdout]
  begin
    Glimmer::Config.logger.level = ENV['GLIMMER_LOGGER_LEVEL'].strip
  rescue => e
    puts e.message
  end
end

Glimmer::Config.excluded_keyword_checkers << lambda do |method_symbol, *args|
  method = method_symbol.to_s
  result = false
  result ||= method == 'dispose' && is_a?(Glimmer::UI::CustomWidget) && respond_to?(method)
  result ||= ['drag_source_proxy', 'drop_target_proxy'].include?(method) && is_a?(Glimmer::UI::CustomWidget)
  result ||= method == 'post_initialize_child'
  result ||= method == 'handle'
  result ||= method.end_with?('=')
  result ||= ['finish_edit!', 'search', 'all_tree_items', 'depth_first_search'].include?(method) && is_a?(Glimmer::UI::CustomWidget) && body_root.respond_to?(method)
end
