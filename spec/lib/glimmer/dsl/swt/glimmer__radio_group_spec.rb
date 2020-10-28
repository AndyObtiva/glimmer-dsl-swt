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

    it "data-binds selection property" do
      person = Person.new

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

    it "data binds selection property on a custom widget radio_group" do
      person = Person.new

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
