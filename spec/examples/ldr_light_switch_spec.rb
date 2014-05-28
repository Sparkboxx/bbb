require 'spec_helper'
require_relative '../../examples/ldr_light_switch'

describe LDRLightSwitch do
  before :each do
    @switch = described_class.new
  end

  it "has an ldr" do
    @switch.respond_to?(:ldr).should be_true
  end

  it "has an led" do
    @switch.respond_to?(:led).should be_true
  end

  it "led initializes off" do
    @switch.led.off?.should be_true
  end

  it "switches on if the light is below threshold" do
    @switch.threshold = 10
    @switch.led.off!

    @switch.ldr.should_receive(:read).and_return(5)
    @switch.run
    @switch.led.on?.should be_true
  end

  it "switches off if the light is below threshold" do
    @switch.threshold = 10
    @switch.led.on!

    @switch.ldr.should_receive(:read).and_return(15)
    @switch.run
    @switch.led.on?.should be_false
  end
end
