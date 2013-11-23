require 'spec_helper'

describe BBB::Board do
  let(:bbb) {BBB::TestBoard.new}

  it "initializes with a converter" do
    BBB::Board.should_not_receive(:pin_converter)
    converter = "SomeConverter"
    board = BBB::Board.new(converter)
    board.pin_converter.should eql(converter)
  end

  it "initializes with a default configuration" do
    BBB::Board.should_receive(:pin_converter) { 'Default Config' }
    board = BBB::Board.new
  end

  context "setting pins" do
    Pin = BBB::IO::DigitalPin

    it "defines input function for input pin" do
      pin = Pin.new(:input, nil, :P8_3)
      bbb.setup_pin(pin)
      bbb.respond_to?("p8_3").should be_true
    end

    it "defines output function for input pin" do
      pin = Pin.new(:output, nil, :P8_3)
      bbb.setup_pin(pin)
      bbb.respond_to?("p8_3=").should be_true
    end

    it "enables output function for output pin" do
      pin = Pin.new(:output, nil, :P8_3)
      bbb.setup_pin(pin)
      bbb.p8_3=:low
      pin.status.should eql(:low)
    end

    it "should keep the reference to the pin" do
      pin = Pin.new(:output, nil, :P8_4)
      bbb.connect_io_pin(pin)
      pin.write :high
      bbb.p8_4.should eql(:high)
    end

  end

end
