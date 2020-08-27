require 'glimmer/swt/style_constantizable'

module Glimmer
  module SWT
    # Proxy for org.eclipse.swt.SWT
    #
    # Follows the Proxy Design Pattern
    class SWTProxy            
      include StyleConstantizable      

      class << self
        JAVA_IMPORT = 'org.eclipse.swt.SWT'
        
        java_import JAVA_IMPORT
        
        def constant_java_import 
          JAVA_IMPORT
        end

        def constant_source_class
          SWT
        end

        def constant_value_none
          SWT::NONE
        end
        
        def extra_styles
          EXTRA_STYLES
        end
      end
      
      # Extra styles outside of SWT constants. They are either composite of
      # multiple SWT style constants or brand new styles (with value set to -7)
      EXTRA_STYLES = {
        NO_RESIZE: self[:shell_trim, :resize!, :max!],
        NO_SORT: -7,
        NO_MARGIN: -7,
      }            
    end
  end
end
