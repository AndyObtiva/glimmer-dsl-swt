require 'glimmer/swt/style_constantizable'

module Glimmer
  module SWT
    # Proxy for org.eclipse.swt.dnd.DND
    #
    # Follows the Proxy Design Pattern
    class DNDProxy            
      include StyleConstantizable      

      class << self
        JAVA_IMPORT = 'org.eclipse.swt.dnd.DND'
        
        java_import JAVA_IMPORT
        
        def constant_java_import 
          JAVA_IMPORT
        end

        def constant_source_class
          DND
        end

        def constant_value_none
          DND::DROP_NONE
        end
        
        def extra_styles
          {}
        end
      end
    end
  end
end
