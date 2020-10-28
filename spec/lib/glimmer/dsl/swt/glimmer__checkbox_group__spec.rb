require "spec_helper"

module GlimmerSpec
  describe "Glimmer Radio Group" do
    include Glimmer

    before(:all) do
      class Person
        attr_accessor :countries, :country_options

        def initialize
          self.country_options=["Canada", "US", "Mexico"]
        end
      end

      class ::RedCheckboxGroup
        include Glimmer::UI::CustomWidget

        body {
          checkbox_group(swt_style) {
            background :red
          }
        }
      end
    end

    after(:all) do
      Object.send(:remove_const, :Person) if Object.const_defined?(:Person)
      Object.send(:remove_const, :RedCheckboxGroup) if Object.const_defined?(:RedCheckboxGroup)
    end
    
    let(:person) {Person.new}
    
    it 'sets items, spawning checkboxes' do
      @target = shell {
        @checkbox_group = checkbox_group {
          items person.country_options
        }
      }
      @checkbox_group.checkboxes.each do |checkbox|
        expect(checkbox.swt_widget).to be_a(Button)
        expect(checkbox).to have_style(:check)
      end
    end

    it 'sets selection in items, selecting checkboxes accordingly' do
      @target = shell {
        @checkbox_group = check_group {
          items person.country_options
          selection ['US', 'Mexico']
        }
      }
      @checkbox_group.checkboxes.each do |checkbox|
        expect(checkbox.swt_widget).to be_a(Button)
        expect(checkbox).to have_style(:check)
      end      
      pd @checkbox_group.checkboxes.map(&:selection)
      expect(@checkbox_group.checkboxes[0].selection).to be_falsey
      expect(@checkbox_group.checkboxes[1].selection).to be_truthy
      expect(@checkbox_group.checkboxes[2].selection).to be_truthy
    end
    
    xit 'sets attribute (background) on checkbox group including all nested widgets' do
      @color = rgb(2, 102, 202).swt_color
      @target = shell {
        @checkbox_group = checkbox_group {
          items person.country_options
          background @color
        }
      }
      @checkbox_group.checkboxes.each do |checkbox|
        expect(checkbox.background).to eq(@color)
      end
      @checkbox_group.labels.each do |label|
        expect(label.background).to eq(@color)
      end
      @checkbox_group.children.each do |composite|
        expect(composite.background).to eq(@color)
      end
      expect(@checkbox_group.background).to eq(@color)
    end
    
    xit 'adds selection listener to checkbox_group spawned checkboxes and mouse_up to matching labels' do
      @listener_fired = false
      @target = shell {
        @checkbox_group = checkbox_group {
          items person.country_options
          on_widget_selected { |event|
            expect(@checkbox_group.selection).to eq('Mexico')
            expect(@checkbox_group.selection_indices).to eq(2)
            @listener_fired = true
          }
        }
      }
      @checkbox_group.checkboxes[2].selection = true
      event = Event.new
      event.doit = true
      event.display = display.swt_display
      event.item = @checkbox_group.checkboxes[2].swt_widget
      event.widget = @checkbox_group.checkboxes[2].swt_widget
      event.type = Glimmer::SWT::SWTProxy[:selection]
      @checkbox_group.checkboxes[2].notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)      
      expect(@listener_fired).to be_truthy
      
      @listener_fired = false
      @checkbox_group.selection = 'Canada'
      
      event = Event.new
      event.doit = true
      event.display = display.swt_display
      event.item = @checkbox_group.labels[2].swt_widget
      event.widget = @checkbox_group.labels[2].swt_widget
      event.type = Glimmer::SWT::SWTProxy[:mouseup]
      @checkbox_group.labels[2].notifyListeners(Glimmer::SWT::SWTProxy[:mouseup], event)
      expect(@listener_fired).to be_truthy
    end

    xit 'adds mouse_up listener to checkbox_group spawned checkboxes and labels' do
      @listener_fired = false
      @target = shell {
        @checkbox_group = checkbox_group {
          items person.country_options
          on_mouse_up { |event|
            expect(@checkbox_group.selection).to eq('Mexico')
            expect(@checkbox_group.selection_indices).to eq(2)
            @listener_fired = true
          }
        }
      }
      @checkbox_group.checkboxes[2].selection = true
      event = Event.new
      event.doit = true
      event.display = display.swt_display
      event.item = @checkbox_group.checkboxes[2].swt_widget
      event.widget = @checkbox_group.checkboxes[2].swt_widget
      event.type = Glimmer::SWT::SWTProxy[:mouseup]
      @checkbox_group.checkboxes[2].swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:mouseup], event)
      expect(@listener_fired).to be_truthy
      
      @listener_fired = false
      @checkbox_group.selection = 'Canada'
      
      event = Event.new
      event.doit = true
      event.display = display.swt_display
      event.item = @checkbox_group.labels[2].swt_widget
      event.widget = @checkbox_group.labels[2].swt_widget
      event.type = Glimmer::SWT::SWTProxy[:mouseup]
      @checkbox_group.labels[2].swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:mouseup], event)
      expect(@listener_fired).to be_truthy
    end

    xit 'data-binds selection property' do      
      @target = shell {
        @checkbox_group = checkbox_group {
          selection bind(person, :country)
        }
      }

      expect(@checkbox_group.checkboxes.count).to eq(3)
      @checkbox_group.checkboxes.each do |checkbox|
        expect(checkbox.selection).to be_falsey
      end
      expect(@checkbox_group.selection).to eq("")
      expect(@checkbox_group.selection_indices).to eq(-1)
      expect(@checkbox_group.items).to eq(person.country_options)

      person.country = "Canada"

      expect(@checkbox_group.checkboxes[0].selection).to be_truthy
      expect(@checkbox_group.checkboxes[1].selection).to be_falsey
      expect(@checkbox_group.checkboxes[2].selection).to be_falsey
      expect(@checkbox_group.selection).to eq("Canada")
      expect(@checkbox_group.selection_indices).to eq(0)

      person.country_options << "France"

      expect(@checkbox_group.checkboxes.count).to eq(4)

      person.country_options = ["Canada", "US", "Mexico", "Russia", "France"]

      expect(@checkbox_group.checkboxes.count).to eq(5)

      person.country_options << "Italy"
      person.country_options << "Germany"
      person.country_options.unshift "Australia"

      expect(@checkbox_group.checkboxes.count).to eq(8)

      expect(@checkbox_group.checkboxes[0].selection).to be_falsey
      expect(@checkbox_group.checkboxes[1].selection).to be_truthy
      @checkbox_group.checkboxes[2..-1].each do |checkbox|
        expect(checkbox.selection).to be_falsey
      end
      expect(@checkbox_group.selection).to eq("Canada")
      expect(@checkbox_group.selection_indices).to eq(1)
      
      person.country_options -= ['Canada']

      @checkbox_group.checkboxes.each do |checkbox|
        expect(checkbox.selection).to be_falsey
      end      
      expect(@checkbox_group.selection).to eq("")
      expect(@checkbox_group.selection_indices).to eq(-1)

      @checkbox_group.select(2)
      event = Event.new
      event.doit = true
      event.display = display.swt_display
      event.item = @checkbox_group.checkboxes[2].swt_widget
      event.widget = @checkbox_group.checkboxes[2].swt_widget
      event.type = Glimmer::SWT::SWTProxy[:selection]
      @checkbox_group.checkboxes[2].notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)
      expect(@checkbox_group.checkboxes[2].selection).to be_truthy
      (@checkbox_group.checkboxes[0..1] + @checkbox_group.checkboxes[3..-1]).each do |checkbox|
        expect(checkbox.selection).to be_falsey
      end      
      expect(person.country).to eq("Mexico")

      person.country = "Russia"

      expect(@checkbox_group.checkboxes[3].selection).to be_truthy
      (@checkbox_group.checkboxes[0..2] + @checkbox_group.checkboxes[4..-1]).each do |checkbox|
        expect(checkbox.selection).to be_falsey
      end      
      expect(@checkbox_group.selection).to eq("Russia")
      expect(@checkbox_group.selection_indices).to eq(3)

      person.country = "random value not in country options"

      @checkbox_group.checkboxes.each do |checkbox|
        expect(checkbox.selection).to be_falsey
      end      
      expect(@checkbox_group.selection).to eq("")
      expect(@checkbox_group.selection_indices).to eq(-1)

      person.country = ""

      @checkbox_group.checkboxes.each do |checkbox|
        expect(checkbox.selection).to be_falsey
      end      
      expect(@checkbox_group.selection).to eq("")
      expect(@checkbox_group.selection_indices).to eq(-1)

      person.country = nil

      @checkbox_group.checkboxes.each do |checkbox|
        expect(checkbox.selection).to be_falsey
      end      
      expect(@checkbox_group.selection).to eq("")
      expect(@checkbox_group.selection_indices).to eq(-1)
    end

    xit 'data binds selection property on a custom widget checkbox_group' do
      @target = shell {
        @checkbox_group = red_checkbox_group {
          selection bind(person, :country)
        }
      }

      expect(@checkboxbox_group.background).to eq(Glimmer::SWT::ColorProxy.new(:red).swt_color)
      expect(@checkbox_group.checkboxesoxes.count).to eq(3)
      expect(@checkbox_group.selection_indices).to eq(-1)
      expect(@checkbox_group.selection).to eq("")
    end
  end
end
