require 'spec_helper'

describe BBB::GPIO::PinConverter do
  let(:converter) { BBB::GPIO::PinConverter.new }

  it "converts DigitalPin input to DigitalPin" do
    pin = BBB::IO::DigitalPin.new(:input, nil, :P8_3)
    result = converter.convert(pin, mock: true)
    result.kind_of?(BBB::GPIO::DigitalPin).should be_true
    result.mode.should eql(:input)
  end

  it "converts DigitalPin output to DigitalPin" do
    pin = BBB::IO::DigitalPin.new(:output, nil, :P8_3)
    result = converter.convert(pin, mock: true)
    result.kind_of?(BBB::GPIO::DigitalPin).should be_true
    result.mode.should eql(:output)
  end
end
