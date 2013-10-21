require 'spec_helper'

describe BBB::GPIO::DigitalPin do
  let(:digital_pin){ BBB::GPIO::DigitalPin }

  it "should initialize with a pin number and mode" do
    lambda{ digital_pin.new(13, :input) }.should_not raise_exception
  end

  it "should set the pin number" do
    digital_pin.new(13, :input).pin_num.should eql(13)
  end

  it "should set the mode" do
    digital_pin.new(13, :input).mode.should eql(:input)
  end

  it "initialize with unknown mode pin raises exception" do
    lambda{ digital_pin.new(13, "unknown") }.should\
      raise_exception(BBB::UnknownPinModeException)
  end

  context "direction" do
    it "input pin" do
      pin = digital_pin.new(13, :input)
      pin.direction.should eql(pin.gpio_direction_input)
    end

    it "output pin" do
      pin = digital_pin.new(13, :output)
      pin.direction.should eql(pin.gpio_direction_output)
    end

  end

  context "#set mode" do
    it "should set input mode" do
      pin = digital_pin.new(13, :input)
      pin.should_receive(:file_class).and_return(StringIO)
      pin.set_mode.should eql(pin.direction.size)
    end

    it "should set output mode" do
      pin = digital_pin.new(13, :output)
      pin.should_receive(:file_class).and_return(StringIO)
      pin.set_mode.should eql(pin.direction.size)
    end
  end

  it "#io input" do
    pin = digital_pin.new(13, :input)
    pin.should_receive(:file_class).and_return(StringIO)
    StringIO.should_receive(:open).with(anything, "r")
    pin.io
  end

  it "#io output" do
    pin = digital_pin.new(13, :output)
    pin.should_receive(:file_class).and_return(StringIO)
    StringIO.should_receive(:open).with(anything, "w")
    pin.io
  end

  it "should not call the io file twice" do
    pin = digital_pin.new(13, :output)
    pin.should_receive(:file_class).and_return(StringIO)
    StringIO.should_receive(:open).with(anything, "w").once.and_return("foo")
    pin.io; pin.io
  end

end
