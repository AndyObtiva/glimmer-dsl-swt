require "spec_helper"

module GlimmerSpec
  describe "Glimmer Radio Group" do
    include Glimmer

    before(:all) do
      class Person
        attr_accessor :country, :country_options

        def initialize
          self.country_options=["Canada", "US", "Mexico"]
        end
      end

      class ::RedRadioGroup
        include Glimmer::UI::CustomWidget

        body {
          radio_group(swt_style) {
            background :red
          }
        }
      end
    end

    after(:all) do
      Object.send(:remove_const, :Person) if Object.const_defined?(:Person)
      Object.send(:remove_const, :RedRadioGroup) if Object.const_defined?(:RedRadioGroup)
    end
    
    let(:person) {Person.new}
    
    it 'sets items, spawning radios' do
      @target = shell {
        @radio_group = radio_group {
          items person.country_options
        }
      }
      @radio_group.radios.each do |radio|
        expect(radio.swt_widget).to be_a(Button)
        expect(radio).to have_style(:radio)
      end      
    end

    it 'sets selection in items, selecting radio accordingly' do
      @target = shell {
        @radio_group = radio_group {
          items person.country_options
          selection 'US'
        }
      }
      @radio_group.radios.each do |radio|
        expect(radio.swt_widget).to be_a(Button)
        expect(radio).to have_style(:radio)
      end      
      expect(@radio_group.radios[0].selection).to be_falsey
      expect(@radio_group.radios[1].selection).to be_truthy
      expect(@radio_group.radios[2].selection).to be_falsey
    end
    
    it 'sets attribute (background) on radio group including all nested widgets' do
      @color = rgb(2, 102, 202).swt_color
      @target = shell {
        @radio_group = radio_group {
          items person.country_options
          background @color
        }
      }
      @radio_group.radios.each do |radio|
        expect(radio.background).to eq(@color)
      end
      @radio_group.labels.each do |label|
        expect(label.background).to eq(@color)
      end
      @radio_group.children.each do |composite|
        expect(composite.background).to eq(@color)
      end
      expect(@radio_group.background).to eq(@color)
    end
    
    it 'adds selection listener to radio_group spawned radios and mouse_up to matching labels' do
      @listener_fired = false
      @target = shell {
        @radio_group = radio_group {
          items person.country_options
          on_widget_selected { |event|
            expect(@radio_group.selection).to eq('Mexico')
            expect(@radio_group.selection_index).to eq(2)
            @listener_fired = true
          }
        }
      }
      @radio_group.radios[2].selection = true
      event = Event.new
      event.doit = true
      event.display = display.swt_display
      event.item = @radio_group.radios[2].swt_widget
      event.widget = @radio_group.radios[2].swt_widget
      event.type = Glimmer::SWT::SWTProxy[:selection]
      @radio_group.radios[2].notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)      
      expect(@listener_fired).to be_truthy
      
      @listener_fired = false
      @radio_group.selection = 'Canada'
      
      event = Event.new
      event.doit = true
      event.display = display.swt_display
      event.item = @radio_group.labels[2].swt_widget
      event.widget = @radio_group.labels[2].swt_widget
      event.type = Glimmer::SWT::SWTProxy[:mouseup]
      @radio_group.labels[2].notifyListeners(Glimmer::SWT::SWTProxy[:mouseup], event)
      expect(@listener_fired).to be_truthy
    end

    it 'adds mouse_up listener to radio_group spawned radios and labels' do
      @listener_fired = false
      @target = shell {
        @radio_group = radio_group {
          items person.country_options
          on_mouse_up { |event|
            expect(@radio_group.selection).to eq('Mexico')
            expect(@radio_group.selection_index).to eq(2)
            @listener_fired = true
          }
        }
      }
      @radio_group.radios[2].selection = true
      event = Event.new
      event.doit = true
      event.display = display.swt_display
      event.item = @radio_group.radios[2].swt_widget
      event.widget = @radio_group.radios[2].swt_widget
      event.type = Glimmer::SWT::SWTProxy[:mouseup]
      @radio_group.radios[2].swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:mouseup], event)
      expect(@listener_fired).to be_truthy
      
      @listener_fired = false
      @radio_group.selection = 'Canada'
      
      event = Event.new
      event.doit = true
      event.display = display.swt_display
      event.item = @radio_group.labels[2].swt_widget
      event.widget = @radio_group.labels[2].swt_widget
      event.type = Glimmer::SWT::SWTProxy[:mouseup]
      @radio_group.labels[2].swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:mouseup], event)
      expect(@listener_fired).to be_truthy
    end

    it 'data-binds selection property' do      
      @target = shell {
        @radio_group = radio_group {
          selection bind(person, :country)
        }
      }

      expect(@radio_group.radios.count).to eq(3)
      @radio_group.radios.each do |radio|
        expect(radio.selection).to be_falsey
      end
      expect(@radio_group.selection).to eq("")
      expect(@radio_group.selection_index).to eq(-1)
      expect(@radio_group.items).to eq(person.country_options)

      person.country = "Canada"

      expect(@radio_group.radios[0].selection).to be_truthy
      expect(@radio_group.radios[1].selection).to be_falsey
      expect(@radio_group.radios[2].selection).to be_falsey
      expect(@radio_group.selection).to eq("Canada")
      expect(@radio_group.selection_index).to eq(0)

      person.country_options << "France"

      expect(@radio_group.radios.count).to eq(4)

      person.country_options = ["Canada", "US", "Mexico", "Russia", "France"]

      expect(@radio_group.radios.count).to eq(5)

      person.country_options << "Italy"
      person.country_options << "Germany"
      person.country_options.unshift "Australia"

      expect(@radio_group.radios.count).to eq(8)

      expect(@radio_group.radios[0].selection).to be_falsey
      expect(@radio_group.radios[1].selection).to be_truthy
      @radio_group.radios[2..-1].each do |radio|
        expect(radio.selection).to be_falsey
      end
      expect(@radio_group.selection).to eq("Canada")
      expect(@radio_group.selection_index).to eq(1)
      
      person.country_options -= ['Canada']

      @radio_group.radios.each do |radio|
        expect(radio.selection).to be_falsey
      end      
      expect(@radio_group.selection).to eq("")
      expect(@radio_group.selection_index).to eq(-1)

      @radio_group.select(2)
      event = Event.new
      event.doit = true
      event.display = display.swt_display
      event.item = @radio_group.radios[2].swt_widget
      event.widget = @radio_group.radios[2].swt_widget
      event.type = Glimmer::SWT::SWTProxy[:selection]
      @radio_group.radios[2].notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)
      expect(@radio_group.radios[2].selection).to be_truthy
      (@radio_group.radios[0..1] + @radio_group.radios[3..-1]).each do |radio|
        expect(radio.selection).to be_falsey
      end      
      expect(person.country).to eq("Mexico")

      person.country = "Russia"

      expect(@radio_group.radios[3].selection).to be_truthy
      (@radio_group.radios[0..2] + @radio_group.radios[4..-1]).each do |radio|
        expect(radio.selection).to be_falsey
      end      
      expect(@radio_group.selection).to eq("Russia")
      expect(@radio_group.selection_index).to eq(3)

      person.country = "random value not in country options"

      @radio_group.radios.each do |radio|
        expect(radio.selection).to be_falsey
      end      
      expect(@radio_group.selection).to eq("")
      expect(@radio_group.selection_index).to eq(-1)

      person.country = ""

      @radio_group.radios.each do |radio|
        expect(radio.selection).to be_falsey
      end      
      expect(@radio_group.selection).to eq("")
      expect(@radio_group.selection_index).to eq(-1)

      person.country = nil

      @radio_group.radios.each do |radio|
        expect(radio.selection).to be_falsey
      end      
      expect(@radio_group.selection).to eq("")
      expect(@radio_group.selection_index).to eq(-1)
    end

    it 'data binds selection property on a custom widget radio_group' do
      @target = shell {
        @radio_group = red_radio_group {
          selection bind(person, :country)
        }
      }

      expect(@radio_group.background).to eq(Glimmer::SWT::ColorProxy.new(:red).swt_color)
      expect(@radio_group.radios.count).to eq(3)
      expect(@radio_group.selection_index).to eq(-1)
      expect(@radio_group.selection).to eq("")
    end
  end
end
