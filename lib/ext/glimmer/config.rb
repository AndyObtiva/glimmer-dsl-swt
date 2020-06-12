module Glimmer
  module Config
    class << self
      # Tells Glimmer to import SWT packages into including class (default: true)
      def import_swt_packages=(value)
        @@import_swt_packages = !!value
      end
  
      # Returns whether Glimmer will import SWT packages into including class
      def import_swt_packages
        unless defined? @@import_swt_packages
          @@import_swt_packages = true
        end
        @@import_swt_packages
      end
    end
  end
end
