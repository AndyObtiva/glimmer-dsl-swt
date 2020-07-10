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
    end
  end
end
