require 'spec_helper'

describe BBB::Pins::DigitalOutputPin do
  let(:pin) { BBB::Pins::DigitalOutputPin.new(:P8_4, mock: true)}

  it "initializes with the direction :output" do
    pin.direction.should eql(:output)
  end

  it "is a kind of digital pin" do
    pin.kind_of?(BBB::Pins::DigitalPin).should be_true
  end
end

