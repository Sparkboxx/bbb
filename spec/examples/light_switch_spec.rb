require 'spec_helper'
require_relative '../../examples/light_switch'

describe LightSwitch do

  it "turns on the light by default" do
    LightSwitch.new.led.on?.should be_true
  end

  context "switching lights" do

    it "toggles the light on button press" do
      switch = LightSwitch.new
      old_state = switch.led.status
      switch.button.update(true)
      old_state.should_not eql(switch.led.status)
    end

    it "when keeping pressed do not switch" do
      switch = LightSwitch.new

      state0 = switch.led.status
      switch.button.update(true)

      state1 = switch.led.status
      state0.should_not eql(state1)

      switch.button.update(true)
      state2 = switch.led.status
      state2.should eql(state1)
    end

    it "when keeping released do not switch state" do
      switch = LightSwitch.new

      state0 = switch.led.status
      switch.button.update(false)

      state1 = switch.led.status
      state0.should eql(state1)

      switch.button.update(false)
      state2 = switch.led.status
      state2.should eql(state1)
    end
  end
end
