require 'spec_helper'

describe BBB::GPIO::DigitalPin do
  let(:digital_pin) { BBB::GPIO::DigitalPin }
  let(:input_pin)   { BBB::GPIO::DigitalPin.new(:p8_9, :input, mock: true) }
  let(:output_pin)  { BBB::GPIO::DigitalPin.new(:p8_3, :output, mock: true) }

  it "should initialize with a pin number and mode" do
    lambda{ input_pin }.should_not raise_exception
  end

  it "should set the pin number" do
    input_pin.position.should eql(:p8_9)
  end

  it "should set the mode" do
    input_pin.mode.should eql(:input)
  end

  it "initialize with unknown mode pin raises exception" do
    lambda{ digital_pin.new(:p8_3, "unknown", mock: true) }.should\
      raise_exception(BBB::UnknownPinModeException)
  end

  context "direction" do
    it "input pin" do
      pin = input_pin
      pin.direction.should eql(pin.gpio_direction_input)
    end

    it "output pin" do
      pin = output_pin
      pin.direction.should eql(pin.gpio_direction_output)
    end
  end

  context "#set mode" do
    ##
    # Temporarily disabled because of inability to catch results of
    # StringIO.open. Possible solution is factoring out the direction_file
    # argument and then use a real file system call to a different file to test
    # this.
    xit "should set input mode" do
      pin = input_pin
      pin.set_mode.string.should eql(pin.direction.size)
    end

    ##
    # Temporarily disabled because of inability to catch results of
    # StringIO.open. Possible solution is factoring out the direction_file
    # argument and then use a real file system call to a different file to test
    # this.
    xit "should set output mode" do
      pin = output_pin
      pin.set_mode.string.should eql(pin.direction.size)
    end
  end

  it "#io input" do
    pin = input_pin
    StringIO.should_receive(:open).with(anything, "r")
    pin.io
  end

  it "#io output" do
    pin = output_pin
    StringIO.should_receive(:open).with(anything, "w+")
    pin.io
  end

  it "should not call the io file twice" do
    pin = output_pin
    StringIO.should_receive(:open).with(anything, "w+").once.and_return("foo")
    pin.io; pin.io
  end

  it "should write :low as 0 to io" do
    pin = output_pin
    pin.io.should_receive(:write).with(0)
    pin.write(:low)
  end

  it "should write :high as 1 to io" do
    pin = output_pin
    pin.io.should_receive(:write).with(1)
    pin.write(:high)
  end

  it "should read 1 as :high from io" do
    pin = output_pin
    pin.io.should_receive(:read).and_return(1)
    pin.read.should eql(:high)
  end

  it "should read 0 as :low from io" do
    pin = output_pin
    pin.io.should_receive(:read).and_return(0)
    pin.read.should eql(:low)
  end
end
