# Copyright (c) 2007-2022 Andy Maleh
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

module Glimmer
  module SWT
    module Properties
      class << self
        def ruby_attribute_setter(attribute_name)
          @ruby_attribute_setters ||= {}
          @ruby_attribute_setters[attribute_name] ||= "#{normalized_attribute(attribute_name)}="
        end
  
        def attribute_setter(attribute_name)
          @attribute_setters ||= {}
          @attribute_setters[attribute_name] ||= "set#{normalized_attribute(attribute_name).camelcase(:upper)}"
        end
  
        def attribute_getter(attribute_name)
          @attribute_getters ||= {}
          @attribute_getters[attribute_name] ||= "get#{normalized_attribute(attribute_name).camelcase(:upper)}"
        end
        
        def normalized_attribute(attribute_name)
          @normalized_attributes ||= {}
          if @normalized_attributes[attribute_name].nil?
            attribute_name = attribute_name.to_s if attribute_name.is_a?(Symbol)
            attribute_name = attribute_name.underscore unless attribute_name.downcase?
            attribute_name = attribute_name.sub(/^get_/, '') if attribute_name.start_with?('get_')
            attribute_name = attribute_name.sub(/^set_/, '') if attribute_name.start_with?('set_')
            attribute_name = attribute_name.sub(/=$/, '') if attribute_name.end_with?('=')
            @normalized_attributes[attribute_name] = attribute_name
          end
          @normalized_attributes[attribute_name]
        end
        alias ruby_attribute_getter normalized_attribute
      end
      
      def ruby_attribute_setter(attribute_name)
        Glimmer::SWT::Properties.ruby_attribute_setter(attribute_name)
      end

      def attribute_setter(attribute_name)
        Glimmer::SWT::Properties.attribute_setter(attribute_name)
      end

      def attribute_getter(attribute_name)
        Glimmer::SWT::Properties.attribute_getter(attribute_name)
      end
      
      def normalized_attribute(attribute_name)
        Glimmer::SWT::Properties.normalized_attribute(attribute_name)
      end
      alias ruby_attribute_getter normalized_attribute
      
    end
    
  end
  
end
