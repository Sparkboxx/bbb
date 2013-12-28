require 'spec_helper'

describe BBB::Pins::PWMPin do
  let(:pin) { BBB::Pins::PWMPin.new(:P8_14, mock: true) }

  it "includes pinnable" do
    pin.pinnable?.should be_true
  end

  %w(duty polarity period run).each do |method|
    it "##{method}=(value) && ##{method}" do
      pin.public_send("#{method}=", 123)
      pin.public_send(method).should eql(123)
    end
  end

  context "private methods" do
    it "should default to PWM" do
      BBB::Pins::IO::PWM.should_receive(:new)
      pin.send(:default_io)
    end
  end

end
