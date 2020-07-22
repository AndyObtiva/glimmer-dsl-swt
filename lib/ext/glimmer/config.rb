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
        @@logging_appender_options = {async: true, auto_flushing: 25, write_size: 5, immediate_at: [:error, :fatal]} unless defined? @@logging_appender_options
        @@logging_appender_options
      end
      
      def logging_appender_options=(custom_options)
        @@logging_appender_options = custom_options
        reset_logger!
      end
      
      def reset_logger!
        self.logger = Logging.logger['glimmer'].tap do |logger| 
          logger.level = Logger::ERROR
          appenders = []
          appenders << Logging.appenders.stdout(logging_appender_options) if logging_devices.include?(:stdout)
          appenders << Logging.appenders.stderr(logging_appender_options) if logging_devices.include?(:stderr)
          appenders << Logging.appenders.rolling_file('log/glimmer.log', logging_appender_options.merge(logging_device_file_options)) if logging_devices.include?(:file)
          Syslog.close if Syslog.opened? if logging_devices.include?(:syslog)
          appenders << Logging.appenders.syslog('glimmer', logging_appender_options) if logging_devices.include?(:syslog)
          logger.appenders = appenders
        end
      end
    end
  end
end

Glimmer::Config.reset_logger!
