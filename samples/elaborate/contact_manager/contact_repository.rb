# Copyright (c) 2007-2020 Andy Maleh
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

require_relative "contact"

class ContactManager
  class ContactRepository
    NAMES_FIRST = %w[
      Liam
      Noah
      William
      James
      Oliver
      Benjamin
      Elijah
      Lucas
      Mason
      Logan
      Alexander
      Ethan
      Jacob
      Michael
      Daniel
      Henry
      Jackson
      Sebastian
      Aiden
      Matthew
      Samuel
      David
      Joseph
      Carter
      Owen
      Wyatt
      John
      Jack
      Luke
      Jayden
      Dylan
      Grayson
      Levi
      Isaac
      Gabriel
      Julian
      Mateo
      Anthony
      Jaxon
      Lincoln
      Joshua
      Christopher
      Andrew
      Theodore
      Caleb
      Ryan
      Asher
      Nathan
      Thomas
      Leo
      Isaiah
      Charles
      Josiah
      Hudson
      Christian
      Hunter
      Connor
      Eli
      Ezra
      Aaron
      Landon
      Adrian
      Jonathan
      Nolan
      Jeremiah
      Easton
      Elias
      Colton
      Cameron
      Carson
      Robert
      Angel
      Maverick
      Nicholas
      Dominic
      Jaxson
      Greyson
      Adam
      Ian
      Austin
      Santiago
      Jordan
      Cooper
      Brayden
      Roman
      Evan
      Ezekiel
      Xaviar
      Jose
      Jace
      Jameson
      Leonardo
      Axel
      Everett
      Kayden
      Miles
      Sawyer
      Jason
      Emma
      Olivia
    ]
    
    NAMES_LAST = %w[
      Smith
      Johnson
      Williams
      Brown
      Jones
      Miller
      Davis
      Wilson
      Anderson
      Taylor
    ]
    
    def initialize(contacts = nil)
      @contacts = contacts || 100.times.map do |n|
        random_first_name_index = (rand*NAMES_FIRST.size).to_i
        random_last_name_index = (rand*NAMES_LAST.size).to_i
        first_name = NAMES_FIRST[random_first_name_index]
        last_name = NAMES_LAST[random_last_name_index]
        email = "#{first_name}@#{last_name}.com".downcase
        Contact.new(
          first_name: first_name,
          last_name: last_name,
          email: email
        )
      end
    end
  
    def find(attribute_filter_map)
      @contacts.find_all do |contact|
        match = true
        attribute_filter_map.keys.each do |attribute_name|
          contact_value = contact.send(attribute_name).downcase
          filter_value = attribute_filter_map[attribute_name].downcase
          match = false unless contact_value.match(filter_value)
        end
        match
      end
    end
  end
end
