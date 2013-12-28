require 'spec_helper'

describe BBB::Components::Led do
  let(:led) {BBB::Components::Led.new}

  before :each do
    led.initialize_pins(:P8_4, mock: true)
  end

  it "initializes off" do
    led.off?
  end

  it "set state: on" do
    led.pin.should_receive(:on!)
    led.on!
  end

  it "set state: off" do
    led.pin.should_receive(:off!)
    led.off!
  end

  it "check state: on?" do
    led.pin.should_receive(:on?)
    led.on?
  end

  it "check state: on?" do
    led.pin.should_receive(:off?)
    led.off?
  end

  context "#pinnable include" do
    it "responds to pinnable?" do
      led.pinnable?.should be_true
    end
  end

end
