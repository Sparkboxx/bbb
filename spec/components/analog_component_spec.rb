require 'spec_helper'

describe BBB::Components::AnalogComponent do
  let(:component) { BBB::Components::AnalogComponent.new }
  let(:component_class) { BBB::Components::AnalogComponent }

  it "includes Pinnable module" do
    component.pinnable?.should be_true
  end

  it "registers AnalogPin" do
    component_class.pins.should eql([BBB::Pins::AnalogPin])
  end

  context "initialized" do
    before :each do
      @c = component
      @c.initialize_pins(:P8_13)
    end

    it "#pin" do
      @c.pin.class.should eql(BBB::Pins::AnalogPin)
    end

    it "#read" do
      @c.pin.should_receive(:read)
      @c.read
    end

    it "#value aliasses #read" do
      @c.should_receive(:read)
      @c.value
    end
  end

end
