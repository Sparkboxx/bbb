require 'spec_helper'

describe BBB::Pins::DigitalInputPin do
  let(:pin) { BBB::Pins::DigitalInputPin.new(:P8_4, mock: true)}

  it "initializes with the direction :input" do
    pin.direction.should eql(:input)
  end

  it "is a kind of digital pin" do
    pin.kind_of?(BBB::Pins::DigitalPin).should be_true
  end
end
