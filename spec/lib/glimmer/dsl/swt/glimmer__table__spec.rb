require "spec_helper"

module GlimmerSpec
  describe "Glimmer Table Data Binding" do
    include Glimmer

    before(:all) do
      class PersonCommunity
        attr_accessor :groups

        def initialize
          @groups = []
        end
      end

      class PersonGroup
        attr_accessor :people
        attr_accessor :selected_person
        attr_accessor :selected_people

        def initialize
          @people = []
        end
      end

      class Person
        attr_accessor :name, :age, :adult, :dob, :salary
      end

      class ::RedTable
        include Glimmer::UI::CustomWidget

        body {
          table(swt_style) {
            background :red
          }
        }
      end
    end

    after(:all) do
      %w[
        PersonCommunity
        PersonGroup
        Person
        RedTable
      ].each do |constant|
        Object.send(:remove_const, constant) if Object.const_defined?(constant)
      end
    end

    let(:person1) do
      Person.new.tap do |person|
        person.name = "Bruce Ting"
        person.age = 45
        person.adult = true
        person.dob = Time.new(1950, 4, 17, 13, 3, 55)
        person.salary = 133000.50
      end
    end

    let(:person2) do
      Person.new.tap do |person|
        person.name = "Julia Fang"
        person.age = 17
        person.adult = false
        person.dob = Time.new(1978, 11, 27, 22, 47, 25)
        person.salary = 99000.7
      end
    end
    
    let(:selected_person) { person2 }
    let(:selected_people) { [person1, person2] }
    
    let(:group) do    
      PersonGroup.new.tap do |g|
        g.people << person1
        g.people << person2
        g.selected_person = selected_person
        g.selected_people = selected_people
      end
    end

    let(:community) do
      PersonCommunity.new.tap do |c|
        c.groups << group
      end
    end 
    
    context 'data-binding' do
      context 'read' do
        it "data binds table items" do
          @target = shell {
            @table = table {
              table_column {
                text "Name"
                width 120
              }
              table_column {
                text "Age"
                width 120
              }
              table_column {
                text "Adult"
                width 120
              }
              items bind(group, :people), column_properties(:name, :age, :adult)
            }
            @table_nested_indexed = table {
              table_column {
                text "Name"
                width 120
              }
              table_column {
                text "Age"
                width 120
              }
              table_column {
                text "Adult"
                width 120
              }
              items bind(community, "groups[0].people"), column_properties(:name, :age, :adult)
            }
          }
    
          expect(@table.swt_widget.getColumnCount).to eq(3)
          expect(@table.swt_widget.getItems.size).to eq(2)
    
          expect(@table.swt_widget.getItems[0].getText(0)).to eq("Bruce Ting")
          expect(@table.swt_widget.getItems[0].getText(1)).to eq("45")
          expect(@table.swt_widget.getItems[0].getText(2)).to eq("true")
    
          expect(@table.swt_widget.getItems[1].getText(0)).to eq("Julia Fang")
          expect(@table.swt_widget.getItems[1].getText(1)).to eq("17")
          expect(@table.swt_widget.getItems[1].getText(2)).to eq("false")
    
          expect(@table_nested_indexed.swt_widget.getColumnCount).to eq(3)
          expect(@table_nested_indexed.swt_widget.getItems.size).to eq(2)
    
          expect(@table_nested_indexed.swt_widget.getItems[0].getText(0)).to eq("Bruce Ting")
          expect(@table_nested_indexed.swt_widget.getItems[0].getText(1)).to eq("45")
          expect(@table_nested_indexed.swt_widget.getItems[0].getText(2)).to eq("true")
    
          expect(@table_nested_indexed.swt_widget.getItems[1].getText(0)).to eq("Julia Fang")
          expect(@table_nested_indexed.swt_widget.getItems[1].getText(1)).to eq("17")
          expect(@table_nested_indexed.swt_widget.getItems[1].getText(2)).to eq("false")
    
          person3 = Person.new
          person3.name = "Andrea Sherlock"
          person3.age = 23
          person3.adult = true
    
          group.people << person3
    
          expect(@table.swt_widget.getItems.size).to eq(3)
          expect(@table.swt_widget.getItems[2].getText(0)).to eq("Andrea Sherlock")
          expect(@table.swt_widget.getItems[2].getText(1)).to eq("23")
          expect(@table.swt_widget.getItems[2].getText(2)).to eq("true")
    
          person3.name = "Andrea Sherloque"
          person3.age = 13
          person3.adult = false
    
          expect(@table.swt_widget.getItems[2].getText(0)).to eq("Andrea Sherloque")
          expect(@table.swt_widget.getItems[2].getText(1)).to eq("13")
          expect(@table.swt_widget.getItems[2].getText(2)).to eq("false")
    
          group.people.delete person2
    
          expect(@table.swt_widget.getItems.size).to eq(2)
          expect(@table.swt_widget.getItems[1].getText(0)).to eq("Andrea Sherloque")
          expect(@table.swt_widget.getItems[1].getText(1)).to eq("13")
          expect(@table.swt_widget.getItems[1].getText(2)).to eq("false")
    
          group.people.delete_at(0)
    
          expect(@table.swt_widget.getItems.size).to eq(1)
          expect(@table.swt_widget.getItems[0].getText(0)).to eq("Andrea Sherloque")
          expect(@table.swt_widget.getItems[0].getText(1)).to eq("13")
          expect(@table.swt_widget.getItems[0].getText(2)).to eq("false")
    
          group.people.clear
    
          expect(0).to eq(@table.swt_widget.getItems.size)
    
          group.people = [person2, person1]
    
          expect(2).to eq(@table.swt_widget.getItems.size)
    
          expect(@table.swt_widget.getItems[0].getText(0)).to eq("Julia Fang")
          expect(@table.swt_widget.getItems[0].getText(1)).to eq("17")
          expect(@table.swt_widget.getItems[0].getText(2)).to eq("false")
    
          expect(@table.swt_widget.getItems[1].getText(0)).to eq("Bruce Ting")
          expect(@table.swt_widget.getItems[1].getText(1)).to eq("45")
          expect(@table.swt_widget.getItems[1].getText(2)).to eq("true")
    
          person1.name = "Bruce Flee"
    
          expect(@table.swt_widget.getItems[1].getText(0)).to eq("Bruce Flee")
        end
    
        it "data binds table single selection" do
          @target = shell {
            @table = table {
              table_column {
                text "Name"
                width 120
              }
              table_column {
                text "Age"
                width 120
              }
              table_column {
                text "Adult"
                width 120
              }
              items bind(group, :people), column_properties(:name, :age, :adult)
              selection bind(group, :selected_person)
            }
          }
    
          selection = @table.swt_widget.getSelection      
          expect(selection.size).to eq(1)
          expect(selection.first.getData).to eq(person2)
    
          person3 = Person.new
          person3.name = "Andrea Sherlock"
          person3.age = 23
          person3.adult = true
          
          group.people << person3
    
          selection = @table.swt_widget.getSelection
          expect(selection.size).to eq(1)
          expect(selection.first.getData).to eq(person2)
    
          group.people.delete person2
    
          selection = @table.swt_widget.getSelection
          expect(selection.size).to eq(1)
          expect(selection.first.getData).to eq(person1)
    
          group.selected_person = person1
    
          selection = @table.swt_widget.getSelection
          expect(selection.size).to eq(1)
          expect(selection.first.getData).to eq(person1)
    
          # TODO test triggering selection from table directly
        end
    
        it "data binds table multi selection" do
          @target = shell {
            @table = table(:multi) {
              table_column {
                text "Name"
                width 120
              }
              table_column {
                text "Age"
                width 120
              }
              table_column {
                text "Adult"
                width 120
              }
              items bind(group, :people), column_properties(:name, :age, :adult)
              selection bind(group, :selected_people)
            }
          }
    
          selection = @table.swt_widget.getSelection      
          expect(selection.size).to eq(2)
          expect(selection[0].getData).to eq(person1)
          expect(selection[1].getData).to eq(person2)
    
          person3 = Person.new
          person3.name = "Andrea Sherlock"
          person3.age = 23
          person3.adult = true
          
          group.people << person3
    
          selection = @table.swt_widget.getSelection
          expect(selection.size).to eq(2)
          expect(selection[0].getData).to eq(person1)
          expect(selection[1].getData).to eq(person2)
    
          group.people.delete person2
    
          selection = @table.swt_widget.getSelection
          expect(selection.size).to eq(1)
          expect(selection.first.getData).to eq(person1)
    
          group.selected_people = [person1, person3]
    
          selection = @table.swt_widget.getSelection
          expect(selection.size).to eq(2)
          expect(selection[0].getData).to eq(person1)
          expect(selection[1].getData).to eq(person3)
          
          # TODO test triggering selection from table directly
        end
    
        it "data binds text widget to a string property for a custom widget table" do
          @target = shell {
            @table = red_table {
              table_column {
                text "Name"
                width 120
              }
              table_column {
                text "Age"
                width 120
              }
              table_column {
                text "Adult"
                width 120
              }
              items bind(group, :people), column_properties(:name, :age, :adult)
            }
          }
    
          expect(@table.swt_widget.getBackground).to eq(Glimmer::SWT::ColorProxy.new(:red).swt_color)
          expect(@table.swt_widget.getColumnCount).to eq(3)
          expect(@table.swt_widget.getItems.size).to eq(2)
    
          expect(@table.swt_widget.getItems[0].getText(0)).to eq("Bruce Ting")
          expect(@table.swt_widget.getItems[0].getText(1)).to eq("45")
          expect(@table.swt_widget.getItems[0].getText(2)).to eq("true")
    
          expect(@table.swt_widget.getItems[1].getText(0)).to eq("Julia Fang")
          expect(@table.swt_widget.getItems[1].getText(1)).to eq("17")
          expect(@table.swt_widget.getItems[1].getText(2)).to eq("false")
        end
      end
      
      context 'write (edit)' do
        it "triggers table widget editing on selected table item which is done via ENTER key" do
          @target = shell {
            @table = table {
              table_column {
                text "Name"
                width 120
              }
              table_column {
                text "Age"
                width 120
              }
              table_column {
                text "Adult"
                width 120
              }
              items bind(group, :people), column_properties(:name, :age, :adult)
              selection bind(group, :selected_person)
            }
          }
          
          expect(@table.table_editor_text_proxy).to be_nil
          @write_done = false
          @table.edit_selected_table_item(
            0,
            before_write: lambda {
              expect(@table.edit_in_progress?).to eq(true)
            }, 
            after_write: lambda { |edited_table_item|
              expect(edited_table_item.getText(0)).to eq('Julie Fan')
              @write_done = true 
            }
          )      
          expect(@table.table_editor_text_proxy).to_not be_nil
          @table.table_editor_text_proxy.swt_widget.setText('Julie Fan')
          # simulate hitting enter to trigger write action
          event = Event.new
          event.keyCode = Glimmer::SWT::SWTProxy[:cr]
          event.doit = true
          event.character = "\n"
          event.display = @table.table_editor_text_proxy.swt_widget.getDisplay
          event.item = @table.table_editor_text_proxy.swt_widget
          event.widget = @table.table_editor_text_proxy.swt_widget
          event.type = Glimmer::SWT::SWTProxy[:keydown]
          @table.table_editor_text_proxy.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:keydown], event)
          expect(@write_done).to eq(true)
          expect(@table.edit_in_progress?).to eq(false)
          expect(@cancel_done).to be_nil
          expect(person2.name).to eq('Julie Fan')
          
          # test that it maintains selection
          selection = @table.swt_widget.getSelection
          expect(selection.size).to eq(1)
          expect(selection.first.getData).to eq(person2)            
        end    
        
        it "triggers table widget editing on specified table item which is done via ENTER key" do
          @target = shell {
            @table = table {
              table_column {
                text "Name"
                width 120
              }
              table_column {
                text "Age"
                width 120
              }
              table_column {
                text "Adult"
                width 120
              }
              items bind(group, :people), column_properties(:name, :age, :adult)
              selection bind(group, :selected_person)
            }
          }
          
          expect(@table.table_editor_text_proxy).to be_nil
          @write_done = false
          @table.edit_table_item(
            @table.swt_widget.getItems.first,
            0,
            before_write: lambda {
              expect(@table.edit_in_progress?).to eq(true)
            }, 
            after_write: lambda { |edited_table_item|
              expect(edited_table_item.getText(0)).to eq('Julie Fan')
              @write_done = true 
            }
          )      
          expect(@table.table_editor_text_proxy).to_not be_nil
          @table.table_editor_text_proxy.swt_widget.setText('Julie Fan')
          # simulate hitting enter to trigger write action
          event = Event.new
          event.keyCode = Glimmer::SWT::SWTProxy[:cr]
          event.doit = true
          event.character = "\n"
          event.display = @table.table_editor_text_proxy.swt_widget.getDisplay
          event.item = @table.table_editor_text_proxy.swt_widget
          event.widget = @table.table_editor_text_proxy.swt_widget
          event.type = Glimmer::SWT::SWTProxy[:keydown]
          @table.table_editor_text_proxy.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:keydown], event)
          expect(@write_done).to eq(true)
          expect(@table.edit_in_progress?).to eq(false)
          expect(@cancel_done).to be_nil
          expect(person1.name).to eq('Julie Fan')
          
          expect(@table.table_editor_text_proxy).to be_nil
          @write_done = false
          @table.edit_table_item(
            @table.swt_widget.getItems.first,
            1,
            before_write: lambda {
              expect(@table.edit_in_progress?).to eq(true)
            }, 
            after_write: lambda { |edited_table_item|
              expect(edited_table_item.getText(1)).to eq('32')          
              @write_done = true 
            }
          )      
          expect(@table.table_editor_text_proxy).to_not be_nil
          @table.table_editor_text_proxy.swt_widget.setText('32')
          # simulate hitting enter to trigger write action
          event = Event.new
          event.keyCode = Glimmer::SWT::SWTProxy[:cr]
          event.doit = true
          event.character = "\n"
          event.display = @table.table_editor_text_proxy.swt_widget.getDisplay
          event.item = @table.table_editor_text_proxy.swt_widget
          event.widget = @table.table_editor_text_proxy.swt_widget
          event.type = Glimmer::SWT::SWTProxy[:keydown]
          @table.table_editor_text_proxy.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:keydown], event)
          expect(@write_done).to eq(true)
          expect(@table.edit_in_progress?).to eq(false)
          expect(@cancel_done).to be_nil
          expect(person1.age).to eq('32')
                
          # test that it maintains selection
          selection = @table.swt_widget.getSelection
          expect(selection.size).to eq(1)
          expect(selection.first.getData).to eq(person2)         
        end    
         
        it "triggers table widget editing on selected table item which is done via focus out" do
          @target = shell {
            @table = table {
              table_column {
                text "Name"
                width 120
              }
              table_column {
                text "Age"
                width 120
              }
              table_column {
                text "Adult"
                width 120
              }
              items bind(group, :people), column_properties(:name, :age, :adult)
              selection bind(group, :selected_person)
            }
          }
          
          expect(@table.table_editor_text_proxy).to be_nil
          @write_done = false
          @table.edit_selected_table_item(
            0,
            before_write: lambda {
              expect(@table.edit_in_progress?).to eq(true)
            }, 
            after_write: lambda { |edited_table_item|
              expect(edited_table_item.getText(0)).to eq('Julie Fan')
              @write_done = true 
            }
          )      
          expect(@table.table_editor_text_proxy).to_not be_nil
          @table.table_editor_text_proxy.swt_widget.setText('Julie Fan')
          # simulate hitting enter to trigger write action
          event = Event.new
          event.keyCode = Glimmer::SWT::SWTProxy[:cr]
          event.doit = true
          event.character = "\n"
          event.display = @table.table_editor_text_proxy.swt_widget.getDisplay
          event.item = @table.table_editor_text_proxy.swt_widget
          event.widget = @table.table_editor_text_proxy.swt_widget
          event.type = Glimmer::SWT::SWTProxy[:focusout]
          @table.table_editor_text_proxy.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:focusout], event)
          expect(@write_done).to eq(true)
          expect(@table.edit_in_progress?).to eq(false)
          expect(@cancel_done).to be_nil
          expect(person2.name).to eq('Julie Fan')
          
          # test that it maintains selection
          selection = @table.swt_widget.getSelection
          expect(selection.size).to eq(1)
          expect(selection.first.getData).to eq(person2)
        end
         
        it "triggers table widget editing on selected table item and cancels by not making a change and focusing out" do
          @target = shell {
            @table = table {
              table_column {
                text "Name"
                width 120
              }
              table_column {
                text "Age"
                width 120
              }
              table_column {
                text "Adult"
                width 120 
              }
              items bind(group, :people), column_properties(:name, :age, :adult)
              selection bind(group, :selected_person)
            }
          }
          
          expect(@table.table_editor_text_proxy).to be_nil
          @write_done = false
          @table.edit_selected_table_item(
            0,
            after_write: lambda do |edited_table_item|
              @write_done = true 
            end,
            after_cancel: lambda do
              @cancel_done = true
            end
          )      
          expect(@table.table_editor_text_proxy).to_not be_nil
          # simulate hitting enter to trigger write action
          event = Event.new
          event.keyCode = Glimmer::SWT::SWTProxy[:cr]
          event.doit = true
          event.character = "\n"
          event.display = @table.table_editor_text_proxy.swt_widget.getDisplay
          event.item = @table.table_editor_text_proxy.swt_widget
          event.widget = @table.table_editor_text_proxy.swt_widget
          event.type = Glimmer::SWT::SWTProxy[:focusout]
          @table.table_editor_text_proxy.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:focusout], event)
          expect(@table.edit_in_progress?).to eq(false)
          expect(@write_done).to be_falsey
          expect(@cancel_done).to eq(true)
          expect(person2.name).to eq('Julia Fang')
          
          # test that it maintains selection
          selection = @table.swt_widget.getSelection
          expect(selection.size).to eq(1)
          expect(selection.first.getData).to eq(person2)
        end
         
        it "triggers table widget editing on selected table item and cancels by hitting ESCAPE button" do
          @target = shell {
            @table = table {
              table_column {
                text "Name"
                width 120
              }
              table_column {
                text "Age"
                width 120
              }
              table_column {
                text "Adult"
                width 120 
              }
              items bind(group, :people), column_properties(:name, :age, :adult)
              selection bind(group, :selected_person)
            }
          }
          
          expect(@table.table_editor_text_proxy).to be_nil
          @write_done = false
          @table.edit_selected_table_item(
            0,
            after_write: lambda do |edited_table_item|
              @write_done = true 
            end,
            after_cancel: lambda do
              @cancel_done = true
            end
          )      
          expect(@table.table_editor_text_proxy).to_not be_nil
    
          # simulate hitting escape to trigger write action
          event = Event.new
          event.keyCode = Glimmer::SWT::SWTProxy[:esc]
          event.doit = true
          event.character = nil
          event.display = @table.table_editor_text_proxy.swt_widget.getDisplay
          event.item = @table.table_editor_text_proxy.swt_widget
          event.widget = @table.table_editor_text_proxy.swt_widget
          event.type = Glimmer::SWT::SWTProxy[:keydown]
          @table.table_editor_text_proxy.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:keydown], event)
          
          expect(@table.edit_in_progress?).to eq(false)
          expect(@write_done).to be_falsey
          expect(@cancel_done).to eq(true)
          expect(person2.name).to eq('Julia Fang')
          
          # test that it maintains selection
          selection = @table.swt_widget.getSelection
          expect(selection.size).to eq(1)
          expect(selection.first.getData).to eq(person2)
        end
         
        it "triggers table widget editing on selected table item and cancels by triggering edit on another table item" do
          @target = shell {
            @table = table {
              table_column {
                text "Name"
                width 120
              }
              table_column {
                text "Age"
                width 120
              }
              table_column {
                text "Adult"
                width 120 
              }
              items bind(group, :people), column_properties(:name, :age, :adult)
              selection bind(group, :selected_person)
            }
          }
          
          expect(@table.table_editor_text_proxy).to be_nil
          @write_done = false
          @table.edit_selected_table_item(
            0,
            after_write: lambda do |edited_table_item|
              @write_done = true 
            end,
            after_cancel: lambda do
              @cancel_done = true
            end
          )      
          expect(@table.table_editor_text_proxy).to_not be_nil
          @table.table_editor_text_proxy.swt_widget.setText('Julie Fan')
    
          @write2_done = false
          @table.edit_selected_table_item(
            1,
            after_write: lambda do |edited_table_item|
              @write2_done = true 
            end,
            after_cancel: lambda do
              @cancel2_done = true
            end
          )      
    
          expect(@table.edit_mode?).to eq(true)
          expect(@write_done).to be_falsey
          expect(@cancel_done).to eq(true)
          expect(person2.name).to eq('Julia Fang')
          
          # test that it maintains selection
          selection = @table.swt_widget.getSelection
          expect(selection.size).to eq(1)
          expect(selection.first.getData).to eq(person2)
        end
      end
    end
    
    context 'built-in sorting' do
      it 'automatically supports sorting by a String, Integer, Boolean, Time, and Float column' do
        @target = shell {
          @table = table {
            @table_column1 = table_column {
              text "Name"
              width 120
            }
            @table_column2 = table_column {
              text "Age"
              width 120
            }
            @table_column3 = table_column {
              text "Adult"
              width 120
            }
            @table_column4 = table_column {
              text "Date of Birth"
              width 120
            }
            @table_column5 = table_column {
              text "Salary"
              width 120
            }
            items bind(group, :people), column_properties(:name, :age, :adult, :dob, :salary)
          }
        }
        
        event = Event.new
        event.doit = true
        event.display = @table_column1.swt_widget.getDisplay
        event.item = @table_column1.swt_widget
        event.widget = @table_column1.swt_widget
        event.type = Glimmer::SWT::SWTProxy[:selection]
        @table_column1.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)
  
        expect(@table.swt_widget.items.map {|i| i.get_text(0)}).to eq(['Bruce Ting', 'Julia Fang'])
  
        @table_column1.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)
          
        expect(@table.swt_widget.items.map {|i| i.get_text(0)}).to eq(['Julia Fang', 'Bruce Ting'])
        
        @table_column1.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)
  
        expect(@table.swt_widget.items.map {|i| i.get_text(0)}).to eq(['Bruce Ting', 'Julia Fang'])
  
        event = Event.new
        event.doit = true
        event.display = @table_column2.swt_widget.getDisplay
        event.item = @table_column2.swt_widget
        event.widget = @table_column2.swt_widget
        event.type = Glimmer::SWT::SWTProxy[:selection]
        @table_column2.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)

        expect(@table.swt_widget.items.map {|i| i.get_text(1)}).to eq(['17', '45'])

        @table_column2.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)
        
        expect(@table.swt_widget.items.map {|i| i.get_text(1)}).to eq(['45', '17'])
        
        @table_column2.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)

        expect(@table.swt_widget.items.map {|i| i.get_text(1)}).to eq(['17', '45'])

        event = Event.new
        event.doit = true
        event.display = @table_column3.swt_widget.getDisplay
        event.item = @table_column3.swt_widget
        event.widget = @table_column3.swt_widget
        event.type = Glimmer::SWT::SWTProxy[:selection]
        @table_column3.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)

        expect(@table.swt_widget.items.map {|i| i.get_text(2)}).to eq(['false', 'true'])

        @table_column3.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)
        
        expect(@table.swt_widget.items.map {|i| i.get_text(2)}).to eq(['true', 'false'])
        
        @table_column3.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)

        expect(@table.swt_widget.items.map {|i| i.get_text(2)}).to eq(['false', 'true'])

        event = Event.new
        event.doit = true
        event.display = @table_column4.swt_widget.getDisplay
        event.item = @table_column4.swt_widget
        event.widget = @table_column4.swt_widget
        event.type = Glimmer::SWT::SWTProxy[:selection]
        @table_column4.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)

        expect(@table.swt_widget.items.map {|i| i.get_text(3)}).to eq(['1950-04-17 13:03:55 -0500', '1978-11-27 22:47:25 -0500'])

        @table_column4.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)
        
        expect(@table.swt_widget.items.map {|i| i.get_text(3)}).to eq(['1978-11-27 22:47:25 -0500', '1950-04-17 13:03:55 -0500'])
        
        @table_column4.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)

        expect(@table.swt_widget.items.map {|i| i.get_text(3)}).to eq(['1950-04-17 13:03:55 -0500', '1978-11-27 22:47:25 -0500'])

        event = Event.new
        event.doit = true
        event.display = @table_column5.swt_widget.getDisplay
        event.item = @table_column5.swt_widget
        event.widget = @table_column5.swt_widget
        event.type = Glimmer::SWT::SWTProxy[:selection]
        @table_column5.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)

        expect(@table.swt_widget.items.map {|i| i.get_text(4)}).to eq(%w[99000.7 133000.5])

        @table_column5.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)
        
        expect(@table.swt_widget.items.map {|i| i.get_text(4)}).to eq(%w[133000.5 99000.7])
        
        @table_column5.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)

        expect(@table.swt_widget.items.map {|i| i.get_text(4)}).to eq(%w[99000.7 133000.5])
      end
      
      it 'has sorting disabled' do
        @target = shell {
          @table = table {
            @table_column1 = table_column(:no_sort) {
              text "Name"
              width 120
            }
            items bind(group, :people), column_properties(:name, :age, :adult, :dob)
          }
        }
        
        initial_no_sort_array_of_values = @table.swt_widget.items.map {|i| i.get_text(0)}
        
        event = Event.new
        event.doit = true
        event.display = @table_column1.swt_widget.getDisplay
        event.item = @table_column1.swt_widget
        event.widget = @table_column1.swt_widget
        event.type = Glimmer::SWT::SWTProxy[:selection]
        @table_column1.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)
  
        expect(@table.swt_widget.items.map {|i| i.get_text(0)}).to eq(initial_no_sort_array_of_values)
  
        @table_column1.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)
        
        expect(@table.swt_widget.items.map {|i| i.get_text(0)}).to eq(initial_no_sort_array_of_values)
        
      end      
    end    
    
  end
end