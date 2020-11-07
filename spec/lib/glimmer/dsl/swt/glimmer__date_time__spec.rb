require "spec_helper"

module GlimmerSpec
  describe "Glimmer Date Time" do
    include Glimmer

    before(:all) do
      class Person
        attr_accessor :dob
      end
    end

    after(:all) do
      %w[
        Person
        RedDateTime
      ].each do |constant|
        Object.send(:remove_const, constant) if Object.const_defined?(constant)
      end
    end
    
    let(:person) do
      Person.new.tap do |person|
        person.dob = Time.new(2038, 11, 29, 12, 47, 32)
      end
    end
    
    it "renders date_time with default :date style, data-binding year, month, day" do
      @target = shell {
        @date_time = date_time {
          year bind(person, :dob, on_read: ->(v) {v.year}, on_write: ->(v) {Time.new(v, person.dob.month, person.dob.day, person.dob.hour, person.dob.min, person.dob.sec)})
          month bind(person, :dob, on_read: ->(v) {v.month}, on_write: ->(v) {Time.new(person.dob.year, v, person.dob.day, person.dob.hour, person.dob.min, person.dob.sec)})
          day bind(person, :dob, on_read: ->(v) {v.day}, on_write: ->(v) {Time.new(person.dob.year, person.dob.month, v, person.dob.hour, person.dob.min, person.dob.sec)})
        }
      }

      expect(@date_time).to_not be_nil
      expect(@date_time.swt_widget).to be_a(Java::OrgEclipseSwtWidgets::DateTime)
      expect(@date_time).to have_style(:date)
      expect(@date_time.year).to eq(2038)
      expect(@date_time.month).to eq(11)
      expect(@date_time.day).to eq(29)
      
      @date_time.year = 2020
      event = Event.new
      event.display = @date_time.swt_widget.getDisplay
      event.item = @date_time.swt_widget
      event.widget = @date_time.swt_widget
      event.type = Glimmer::SWT::SWTProxy[:selection]
      @date_time.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)
      expect(person.dob.year).to eq(2020)
      
      @date_time.month = 7
      event = Event.new
      event.display = @date_time.swt_widget.getDisplay
      event.item = @date_time.swt_widget
      event.widget = @date_time.swt_widget
      event.type = Glimmer::SWT::SWTProxy[:selection]
      @date_time.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)
      expect(person.dob.month).to eq(7)
      
      @date_time.day = 18
      event = Event.new
      event.display = @date_time.swt_widget.getDisplay
      event.item = @date_time.swt_widget
      event.widget = @date_time.swt_widget
      event.type = Glimmer::SWT::SWTProxy[:selection]
      @date_time.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)
      expect(person.dob.day).to eq(18)
      
      person.dob = Time.new(2033, 3, 2, 12, 47, 32)
      expect(@date_time.year).to eq(2033)
      expect(@date_time.month).to eq(3)
      expect(@date_time.day).to eq(2)
    end
    
    it "renders date_time with default :date style, data-binding date_time property" do
      @target = shell {
        @date_time = date_time {
          date_time bind(person, :dob)
        }
      }

      expect(@date_time).to_not be_nil
      expect(@date_time.swt_widget).to be_a(Java::OrgEclipseSwtWidgets::DateTime)
      expect(@date_time).to have_style(:date)
      expect(@date_time.date_time).to eq(person.dob)

      @date_time.date_time = Time.new(2013, 1, 12, 2, 7, 3)
      event = Event.new
      event.display = @date_time.swt_widget.getDisplay
      event.item = @date_time.swt_widget
      event.widget = @date_time.swt_widget
      event.type = Glimmer::SWT::SWTProxy[:selection]
      @date_time.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)
      expect(person.dob).to eq(@date_time.date_time)

      person.dob = Time.new(2033, 3, 2, 12, 47, 32)
      expect(@date_time.date_time).to eq(person.dob)
    end
    
    it "renders date_time with :time style, data-binding hour, minute, second" do
      @target = shell {
        @date_time = date_time(:time) {
          hours bind(person, :dob, on_read: ->(v) {v.hour}, on_write: ->(v) {Time.new(person.dob.year, person.dob.month, person.dob.day, v, person.dob.min, person.dob.sec)})
          minutes bind(person, :dob, on_read: ->(v) {v.min}, on_write: ->(v) {Time.new(person.dob.year, person.dob.month, person.dob.day, person.dob.hour, v, person.dob.sec)})
          seconds bind(person, :dob, on_read: ->(v) {v.sec}, on_write: ->(v) {Time.new(person.dob.year, person.dob.month, person.dob.day, person.dob.hour, person.dob.min, v)})
        }
      }

      expect(@date_time).to_not be_nil
      expect(@date_time.swt_widget).to be_a(Java::OrgEclipseSwtWidgets::DateTime)
      expect(@date_time).to have_style(:time)
      expect(@date_time.hours).to eq(12)
      expect(@date_time.minutes).to eq(47)
      expect(@date_time.seconds).to eq(32)
      
      @date_time.hours = 20
      event = Event.new
      event.display = @date_time.swt_widget.getDisplay
      event.item = @date_time.swt_widget
      event.widget = @date_time.swt_widget
      event.type = Glimmer::SWT::SWTProxy[:selection]
      @date_time.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)
      expect(person.dob.hour).to eq(20)
      
      @date_time.minutes = 7
      event = Event.new
      event.display = @date_time.swt_widget.getDisplay
      event.item = @date_time.swt_widget
      event.widget = @date_time.swt_widget
      event.type = Glimmer::SWT::SWTProxy[:selection]
      @date_time.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)
      expect(person.dob.min).to eq(7)
      
      @date_time.seconds = 18
      event = Event.new
      event.display = @date_time.swt_widget.getDisplay
      event.item = @date_time.swt_widget
      event.widget = @date_time.swt_widget
      event.type = Glimmer::SWT::SWTProxy[:selection]
      @date_time.swt_widget.notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)
      expect(person.dob.sec).to eq(18)
      
      person.dob = Time.new(2033, 3, 2, 2, 4, 2)
      expect(@date_time.hours).to eq(2)
      expect(@date_time.minutes).to eq(4)
      expect(@date_time.seconds).to eq(2)
    end

  end
  
end
