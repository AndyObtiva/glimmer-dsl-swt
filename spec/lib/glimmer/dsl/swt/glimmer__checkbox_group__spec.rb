require "spec_helper"

module GlimmerSpec
  describe "Glimmer Radio Group" do
    include Glimmer

    before(:all) do
      class Person
        attr_accessor :countries, :countries_options

        def initialize
          self.countries_options=["Canada", "US", "Mexico"]
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
          items person.countries_options
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
          items person.countries_options
          selection ['US', 'Mexico']
        }
      }
      @checkbox_group.checkboxes.each do |checkbox|
        expect(checkbox.swt_widget).to be_a(Button)
        expect(checkbox).to have_style(:check)
      end      
      expect(@checkbox_group.checkboxes[0].selection).to be_falsey
      expect(@checkbox_group.checkboxes[1].selection).to be_truthy
      expect(@checkbox_group.checkboxes[2].selection).to be_truthy
    end
    
    it 'sets attribute (font) on checkbox group including all nested widgets' do
      @target = shell {
        @checkbox_group = checkbox_group {
          items person.countries_options
          font height: 27
        }
      }
      @checkbox_group.checkboxes.each do |checkbox|
        expect(checkbox.font.font_data.first.height).to eq(27)
      end
      @checkbox_group.labels.each do |label|
        expect(label.font.font_data.first.height).to eq(27)
      end
      @checkbox_group.children.each do |composite|
        expect(composite.font.font_data.first.height).to eq(27)
      end
      expect(@checkbox_group.font.font_data.first.height).to eq(27)
    end
    
    it 'adds selection listener to checkbox_group spawned checkboxes and mouse_up to matching labels' do
      person.countries = ['Canada']
      @listener_fired = false
      @target = shell {
        @checkbox_group = checkbox_group {
          items person.countries_options
          selection person.countries
          on_widget_selected { |event|
            expect(@checkbox_group.selection).to eq(['Canada', 'Mexico'])
            expect(@checkbox_group.selection_indices).to eq([0, 2])
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
      @checkbox_group.checkboxes[2].swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)
      expect(@listener_fired).to be_truthy
      
      @listener_fired = false
      person.countries = ['Canada']
      
      event = Event.new
      event.doit = true
      event.display = display.swt_display
      event.item = @checkbox_group.labels[2].swt_widget
      event.widget = @checkbox_group.labels[2].swt_widget
      event.type = Glimmer::SWT::SWTProxy[:mouseup]
      @checkbox_group.labels[2].swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:mouseup], event)
      expect(@listener_fired).to be_truthy
    end

    it 'adds mouse_up listener to checkbox_group spawned checkboxes and labels' do
      @listener_fired = false
      @target = shell {
        @checkbox_group = checkbox_group {
          items person.countries_options
          on_mouse_up { |event|
            expect(@checkbox_group.selection).to eq(['Mexico'])
            expect(@checkbox_group.selection_indices).to eq([2])
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
      person.countries = ['Canada']
      
      event = Event.new
      event.doit = true
      event.display = display.swt_display
      event.item = @checkbox_group.labels[2].swt_widget
      event.widget = @checkbox_group.labels[2].swt_widget
      event.type = Glimmer::SWT::SWTProxy[:mouseup]
      @checkbox_group.labels[2].swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:mouseup], event)
      expect(@listener_fired).to be_truthy
    end

    it 'data-binds selection property' do      
      @target = shell {
        @checkbox_group = checkbox_group {
          selection bind(person, :countries)
        }
      }

      expect(@checkbox_group.checkboxes.count).to eq(3)
      @checkbox_group.checkboxes.each do |checkbox|
        expect(checkbox.selection).to be_falsey
      end
      expect(@checkbox_group.selection).to eq([])
      expect(@checkbox_group.selection_indices).to eq([])
      expect(@checkbox_group.items).to eq(person.countries_options)

      person.countries = ["Canada", "Mexico"]

      expect(@checkbox_group.checkboxes[0].selection).to be_truthy
      expect(@checkbox_group.checkboxes[1].selection).to be_falsey
      expect(@checkbox_group.checkboxes[2].selection).to be_truthy
      expect(@checkbox_group.selection).to eq(["Canada", "Mexico"])
      expect(@checkbox_group.selection_indices).to eq([0, 2])

      person.countries_options << "France"

      expect(@checkbox_group.checkboxes.count).to eq(4)

      person.countries_options = ["Canada", "US", "Mexico", "Russia", "France"]

      expect(@checkbox_group.checkboxes.count).to eq(5)

      person.countries_options << "Italy"
      person.countries_options << "Germany"
      person.countries_options.unshift "Australia"

      expect(@checkbox_group.checkboxes.count).to eq(8)

      expect(@checkbox_group.checkboxes[0].selection).to be_falsey
      expect(@checkbox_group.checkboxes[1].selection).to be_truthy
      expect(@checkbox_group.checkboxes[2].selection).to be_falsey
      expect(@checkbox_group.checkboxes[3].selection).to be_truthy
      @checkbox_group.checkboxes[4..-1].each do |checkbox|
        expect(checkbox.selection).to be_falsey
      end
      expect(@checkbox_group.selection).to eq(["Canada", "Mexico"])
      expect(@checkbox_group.selection_indices).to eq([1, 3])
      
      person.countries_options -= ['Canada']

      expect(@checkbox_group.checkboxes[2].selection).to be_truthy
      (@checkbox_group.checkboxes - [@checkbox_group.checkboxes[2]]).each do |checkbox|
        expect(checkbox.selection).to be_falsey
      end      
      expect(@checkbox_group.selection).to eq(['Mexico'])
      expect(@checkbox_group.selection_indices).to eq([2])

      @checkbox_group.select([2])
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
      expect(person.countries).to eq(["Mexico"])

      person.countries = ["Russia"]

      expect(@checkbox_group.checkboxes[3].selection).to be_truthy
      (@checkbox_group.checkboxes[0..2] + @checkbox_group.checkboxes[4..-1]).each do |checkbox|
        expect(checkbox.selection).to be_falsey
      end      
      expect(@checkbox_group.selection).to eq(["Russia"])
      expect(@checkbox_group.selection_indices).to eq([3])

      person.countries = ["random value not in country options"]

      @checkbox_group.checkboxes.each do |checkbox|
        expect(checkbox.selection).to be_falsey
      end      
      expect(@checkbox_group.selection).to eq([])
      expect(@checkbox_group.selection_indices).to eq([])

      person.countries = [""]

      @checkbox_group.checkboxes.each do |checkbox|
        expect(checkbox.selection).to be_falsey
      end      
      expect(@checkbox_group.selection).to eq([])
      expect(@checkbox_group.selection_indices).to eq([])

      person.countries = []

      @checkbox_group.checkboxes.each do |checkbox|
        expect(checkbox.selection).to be_falsey
      end      
      expect(@checkbox_group.selection).to eq([])
      expect(@checkbox_group.selection_indices).to eq([])
    end

    it 'data binds selection property on a custom widget checkbox_group' do
      person.countries = ['US', 'Mexico']
      @target = shell {
        @checkbox_group = red_checkbox_group {
          selection bind(person, :countries)
        }
      }

      expect(@checkbox_group.background).to eq(Glimmer::SWT::ColorProxy.new(:red).swt_color)
      expect(@checkbox_group.checkboxes.count).to eq(3)
      expect(@checkbox_group.selection_indices).to eq([1, 2])
      expect(@checkbox_group.selection).to eq(['US', 'Mexico'])
    end
  end
end
