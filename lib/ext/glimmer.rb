require 'glimmer/swt/packages'

module Glimmer
  class << self
    def included(klass)
      if Config.import_swt_packages
        klass.include(SWT::Packages)
        klass.extend(SWT::Packages)
      end
      klass.extend(Glimmer)
    end
  end
end
