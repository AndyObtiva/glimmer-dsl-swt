# Copyright (c) 2007-2024 Andy Maleh
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

require_relative "contact_repository"

class ContactManager
  class ContactManagerPresenter
    attr_accessor :results, :selected_contact
    @@contact_attributes = [:first_name, :last_name, :email]
    @@contact_attributes.each {|attribute_name| attr_accessor attribute_name}
  
    def initialize(contact_repository = nil)
      @contact_repository = contact_repository || ContactRepository.new
      @results = []
    end
  
    def list
      @applied_filter = {}
      filter
    end
  
    def find
      @applied_filter = fields
      filter
    end
    
    def filter
      self.results = @contact_repository.find(@applied_filter)
    end
    
    def fields
      filters = {}
      @@contact_attributes.each do |attribute_name|
        filters[attribute_name] = self.send(attribute_name) if self.send(attribute_name)
      end
      filters
    end
    
    def clear_fields
      @@contact_attributes.each do |attribute_name|
        self.send("#{attribute_name}=", '')
      end
    end
    
    def create
      created_contact = @contact_repository.create(fields)
      filter
      clear_fields
      created_contact
    end
    
    def delete
      deleted_contact = @contact_repository.delete(@selected_contact)
      filter
      self.selected_contact = nil
      deleted_contact
    end
  end
end
