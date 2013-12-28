require "spec_helper"

describe BBB::Circuit do
  let(:c) { BBB::Circuit.new }
  # You can't really avoid some integration testing here
  let(:led) { BBB::Components::Led }

  it "initializes" do
    lambda{ BBB::Circuit.new }.should_not raise_exception
  end

  context "#attach" do
    it "initializes object when passed a class" do
      c.attach led, as: :led
      c.components.values.first.class.should eql(led)
    end

    it "keeps instance when passed an instance" do
      instance = led.new
      c.attach instance, as: :instance
      c.components.values.first.should eql(instance)
    end

    context "naming" do
      it "downcases class names" do
        l = led.new
        c.attach l, as: :led
        c.led.should eql(l)
        c.components[:led].should eql(l)
      end
    end

  end

  class TestAttachCircuit < BBB::Circuit
    def initialize
      attach BBB::Components::Led, pin: :P8_1, as: :led
    end
  end

  it "knows about the attached led" do
    circuit = TestAttachCircuit.new
    circuit.respond_to?(:led).should be_true
  end

end
