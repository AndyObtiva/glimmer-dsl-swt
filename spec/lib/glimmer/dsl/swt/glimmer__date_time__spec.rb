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
    
    it "renders date time with :time style, data-binding year, month, day" do
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
    end
    
    it "renders date time with default :date style, data-binding hour, minute, second" do
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
    end

  end
  
end
