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

require 'glimmer-dsl-swt'

class HelloTree
  EMPLOYEE_ATTRIBUTES = [
    :first_name, :last_name, :position, :salary,
    :health_insurance, :desk_location,
    :sales_bonus_percentage, :merit_bonus,
    :work_expense, :technology_expense, :travel_expense, :client_expense, :sponsorship_expense, :food_expense, :office_expense,
  ]
  
  EmployeeStruct ||= Struct.new(*EMPLOYEE_ATTRIBUTES, keyword_init: true)
  
  class Employee < EmployeeStruct
                
    NAMES_FIRST = %w[
      John
      Noah
      Bill
      James
      Oliver
      Bob
      Laura
      Stephanie
      Marie
      Emma
      Olivia
      Anna
    ]
    
    NAMES_LAST = %w[
      Smith
      Johnson
      Williams
      Brown
      Jones
      Harvard
      Miller
      Davis
      Wilson
      Anderson
      Taylor
      Magnus
    ]
    
    EMPLOYMENT_TYPE_POSITIONS = {
      'Sales'       => 'Sales Person',
      'HR'          => 'HR Staff',
      'Engineering' => 'Engineer',
      'Finance'     => 'Accountant',
    }
        
    SENIORITY_SALARIES = {
      'Senior'      => 111_111,
      'Standard'    => 88_888,
      'Junior'      => 55_555,
    }

    ALL_HEALTH_INSURANCES = [
      'Family Plan',
      'Standard Plan',
      'Minimal Plan',
    ]
        
    class << self
      attr_accessor :selected_employee
    
      def available_names
        @available_names ||= NAMES_FIRST.size.times.map { |n| NAMES_FIRST.rotate(n).zip(NAMES_LAST) }.flatten(1)
      end
      
      def select_name!
        available_names.shift
      end
      
      def all_desk_locations
        @all_desk_locations ||= 30.times.map do |n|
          floor = n + 1
          [
            "Floor #{floor} Sales",
            "Floor #{floor} Engineering",
            "Floor #{floor} HR",
            "Floor #{floor} Finance",
          ]
        end.reduce(:+)
      end
      
      def available_desk_locations
        @available_desk_locations ||= all_desk_locations.clone.reverse
      end
      
      def select_desk_location!(type)
        available_desk_locations.delete(available_desk_locations.detect {|desk_location| desk_location.to_s.end_with?(type)})
      end
      
      def ceo
        @ceo ||= Employee.new(
          position: 'CEO',
          salary: 999_999,
          health_insurance: ALL_HEALTH_INSURANCES[0],
          desk_location: Employee.select_desk_location!('Sales'),
        ).tap do |employee|
          employee.subordinates << cto
          employee.subordinates << cfo
          employee.subordinates << cio
        end
      end
        
      def cto
        @cto ||= Employee.new(
          position: 'CTO',
          salary: 777_777,
          health_insurance: ALL_HEALTH_INSURANCES[0],
          desk_location: Employee.select_desk_location!('Engineering'),
        ).tap do |employee|
          employee.subordinates << vp('Engineering')
        end
      end
      
      def cfo
        @cfo ||= Employee.new(
          position: 'CFO',
          salary: 777_777,
          health_insurance: ALL_HEALTH_INSURANCES[0],
          desk_location: Employee.select_desk_location!('Finance'),
        ).tap do |employee|
          employee.subordinates << vp('Finance')
        end
      end
        
      def cio
        @cio ||= Employee.new(
          position: 'CIO',
          salary: 777_777,
          health_insurance: ALL_HEALTH_INSURANCES[0],
          desk_location: Employee.select_desk_location!('HR'),
        ).tap do |employee|
          employee.subordinates << vp('Sales')
          employee.subordinates << vp('HR')
        end
      end
        
      def vp(type)
        Employee.new(
          position: "VP #{type}",
          salary: 555_555,
          health_insurance: ALL_HEALTH_INSURANCES[0],
          desk_location: Employee.select_desk_location!(type),
        ).tap do |employee|
          2.times { employee.subordinates << director(type) }
        end
      end
        
      def director(type)
        Employee.new(
          position: "Director #{type}",
          salary: 333_333,
          health_insurance: ALL_HEALTH_INSURANCES.sample,
          desk_location: Employee.select_desk_location!(type),
        ).tap do |employee|
          3.times { employee.subordinates << manager(type) }
        end
      end
        
      def manager(type)
        Employee.new(
          position: "Manager #{type}",
          salary: 222_222,
          health_insurance: ALL_HEALTH_INSURANCES.sample,
          desk_location: Employee.select_desk_location!(type),
        ).tap do |employee|
          employee.subordinates << employee(type, 'Senior')
          employee.subordinates << employee(type, 'Standard')
          employee.subordinates << employee(type, 'Junior')
        end
      end
        
      def employee(type, seniority)
        seniority_title = seniority == 'Standard' ? '' : seniority
        Employee.new(
          position: "#{seniority_title} #{EMPLOYMENT_TYPE_POSITIONS[type]}",
          salary: SENIORITY_SALARIES[seniority],
          health_insurance: ALL_HEALTH_INSURANCES.sample,
          desk_location: Employee.select_desk_location!(type),
        )
      end
    end
    
    def initialize(*args)
      super(*args)
      determine_type_from_position
      if first_name.nil? || last_name.nil?
        name = Employee.select_name!
        self.first_name = name.first
        self.last_name = name.last
      end
      self.sales_bonus_percentage = (rand*100).to_i if @type == 'Sales'
      self.merit_bonus = (rand*99_999).to_i
      [:work_expense, :technology_expense, :travel_expense, :client_expense, :sponsorship_expense, :food_expense, :office_expense].each do |attribute|
        self.send("#{attribute}=", rand*9_999)
      end
      observer = Glimmer::DataBinding::Observer.proc {
        notify_observers('to_s')
      }
      observer.observe(self, :first_name)
      observer.observe(self, :last_name)
      observer.observe(self, :position)
    end
    
    def determine_type_from_position(specified_position = nil)
      specified_position ||= position
      @type = EMPLOYMENT_TYPE_POSITIONS.keys.detect {|key| position.include?(key)}
      @type = 'Sales' if position == 'CEO'
      @type = 'Finance' if position == 'CFO'
      @type = 'HR' if position == 'CIO'
      @type = 'Engineering' if position == 'CTO'
    end

    def position_options
      [
        'CEO',
        'CFO',
        'CIO',
        'CTO',
        'VP Sales',
        'VP HR',
        'VP Engineering',
        'VP Finance',
        'Sales Director',
        'HR Director',
        'Engineering Director',
        'Finance Director',
        'Sales Manager',
        'HR Manager',
        'Engineering Manager',
        'Finance Manager',
        'Senior Sales Person',
        'Sales Person',
        'Junior Sales Person',
        'Senior HR Staff',
        'HR Staff',
        'Junior HR Staff',
        'Senior Engineer',
        'Engineer',
        'Junior Engineer',
        'Senior Accountant',
        'Accountant',
        'Junior Accountant',
      ]
    end

    def health_insurance_options
      ALL_HEALTH_INSURANCES
    end

    def desk_location_options
      Employee.all_desk_locations
    end
    
    def subordinates
      @subordinates ||= []
    end

    def to_s
      "#{first_name} #{last_name} (#{position})"
    end
  end

  include Glimmer::UI::CustomShell
  
  before_body do
    Employee.selected_employee = Employee.ceo
  end
  
  after_body do
    @tree.items.first.expanded = true
  end

  body {
    shell {
      fill_layout {
        margin_width 15
        margin_height 15
      }
      text 'Hello, Tree!'
      minimum_size 900, 600
      
      sash_form {
        weights 1, 2
        
        composite {
          fill_layout {
            margin_width 5
            margin_height 5
          }
          @tree = tree {
            items <= [Employee, :ceo, tree_properties: {children: :subordinates, text: :to_s}]
            selection <=> [Employee, :selected_employee]
          }
        }
        
        composite {
          grid_layout 2, false
  
          label {
            layout_data(:fill, :center, false, false)
            text 'First Name:'
            font height: 16, style: :bold
          }
          text {
            layout_data(:fill, :center, true, false)
            text <=> [Employee, "selected_employee.first_name"]
            font height: 16
          }
                  
          label {
            layout_data(:fill, :center, false, false)
            text 'First Name:'
            font height: 16, style: :bold
          }
          text {
            layout_data(:fill, :center, true, false)
            text <=> [Employee, "selected_employee.last_name"]
            font height: 16
          }
                  
          label {
            layout_data(:fill, :center, false, false)
            text 'Position:'
            font height: 16, style: :bold
          }
          combo {
            layout_data(:fill, :center, true, false)
            selection <=> [Employee, "selected_employee.position"]
            font height: 16
          }
                  
          label {
            layout_data(:fill, :center, false, false)
            text 'Salary:'
            font height: 16, style: :bold
          }
          composite {
            layout_data(:fill, :center, true, false)
            row_layout {
              margin_width 0
              margin_height 0
            }
            label {
              text '$'
              font height: 20
            }
            spinner {
              maximum 999_999
              minimum 0
              selection <=> [Employee, "selected_employee.salary"]
              font height: 16
            }
          }

          label {
            layout_data(:fill, :center, false, false)
            text 'Health Insurance:'
            font height: 16, style: :bold
          }
          combo(:read_only) {
            layout_data(:fill, :center, true, false)
            selection <=> [Employee, "selected_employee.health_insurance"]
            font height: 16
          }
                                                  
          label {
            layout_data(:fill, :center, false, false)
            text 'Desk Location:'
            font height: 16, style: :bold
          }
          combo(:read_only) {
            layout_data(:fill, :center, true, false)
            selection <=> [Employee, "selected_employee.desk_location"]
            font height: 16
          }
              
          label {
            layout_data(:fill, :center, false, false)
            text 'Sales Bonus Percentage:'
            font height: 16, style: :bold
          }
          composite {
            layout_data(:fill, :center, true, false)
            row_layout {
              margin_width 0
              margin_height 0
            }
            spinner {
              maximum 100
              minimum 0
              selection <=> [Employee, "selected_employee.sales_bonus_percentage"]
              font height: 16
            }
            label {
              text '%'
              font height: 20
            }
          }

          label {
            layout_data(:fill, :center, false, false)
            text 'Merit Bonus:'
            font height: 16, style: :bold
          }
          composite {
            layout_data(:fill, :center, true, false)
            row_layout {
              margin_width 0
              margin_height 0
            }
            label {
              text '$'
              font height: 20
            }
            spinner {
              maximum 999_999
              minimum 0
              selection <=> [Employee, "selected_employee.merit_bonus"]
              font height: 16
            }
          }
        
          [:work_expense, :technology_expense, :travel_expense, :client_expense, :sponsorship_expense, :food_expense, :office_expense].each do |attribute|
            label {
              layout_data(:fill, :center, false, false)
              text "#{attribute.to_s.split('_').map(&:capitalize).join(' ')}:"
              font height: 16, style: :bold
            }
            composite {
              layout_data(:fill, :center, true, false)
              row_layout {
                margin_width 0
                margin_height 0
              }
              label {
                text '$'
                font height: 20
              }
              spinner {
                digits 2
                maximum 999_999_00
                minimum 0
                increment 100
                selection <=> [Employee, "selected_employee.#{attribute}", on_read: ->(v) {v.to_f * 100}, on_write: ->(v) {v.to_f / 100}]
                font height: 16
              }
            }
          end
        
        }
        
      }
      
    }
    
  }
end

HelloTree.launch
