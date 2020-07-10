require 'glimmer/swt/packages'

module Glimmer
  class << self
    def included(klass)
      if Object.const_defined?(:ActiveSupport) && ActiveSupport.const_defined?(:Dependencies)
        begin
          ActiveSupport::Dependencies.unhook!
        rescue => e
          # noop TODO support logging unimportant details below debug level
        end
      end
      if Config.import_swt_packages
        klass.include(SWT::Packages)
        klass.extend(SWT::Packages)
      end
      klass.extend(Glimmer)
    end
  end
end
