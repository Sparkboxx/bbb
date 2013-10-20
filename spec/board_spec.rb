require 'spec_helper'

describe BBB::Board do
  let(:bbb) {BBB::Board.new}

  it "initializes with a configuration" do
    BBB::Board.should_not_receive(:default_gpio)
    configuration = "SomeConfig"
    board = BBB::Board.new(configuration)
    board.gpio.should eql(configuration)
  end

  it "initializes with a default configuration" do
    BBB::Board.should_receive(:default_gpio) { 'Default Config' }
    board = BBB::Board.new
  end

  context "settings pins" do
    Pin = Struct.new(:type, :address, :value)

    it "define input function for input pin" do
      pin = Pin.new(:input, :P8_1, 1)
      bbb.setup_pin(pin)
      bbb.respond_to?("pin8_1").should be_true
    end

    it "defines output function for output pin" do
      pin = Pin.new(:output, :P8_2, 1)
      bbb.setup_pin(pin)
      bbb.respond_to?("pin8_2=").should be_true
      bbb.pin8_2=0
      pin.value.should eql(0)
    end

    it "defines input function for output pin" do
      pin = Pin.new(:output, :P8_2, 1)
      bbb.setup_pin(pin)
      bbb.respond_to?("pin8_2").should be_true
      bbb.pin8_2.should eql(1)
    end

    it "should keep the reference to the pin" do
      pin = Pin.new(:output, :P8_2, 1)
      bbb.setup_pin(pin)
      pin.value=0
      bbb.pin8_2.should eql(0)
    end

  end

end
