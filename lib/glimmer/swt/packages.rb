require 'ext/glimmer/config'

module Glimmer
  module SWT
    # This contains Java imports of SWT Java packages
    module Packages
      class << self
        def included(klass)
          Glimmer::Config.import_swt_packages.to_a.each do |package|
            include_package(package) if package.is_a?(String)
          end
        end    
      end
    end
  end
end
