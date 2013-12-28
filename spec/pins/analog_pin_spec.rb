require 'spec_helper'

describe BBB::Pins::AnalogPin do
  let(:pin) { BBB::Pins::AnalogPin.new(:P8_4, mock: true)}

  it "includes pinnable" do
    pin.pinnable?.should be_true
  end

  it "#read from io" do
    pin.io.should_receive(:read)
    pin.read
  end

  it "#scale from io" do
    pin.io.should_receive(:scale)
    pin.scale
  end

  it "#scale memorizes the scale" do
    pin.io.should_receive(:scale).once.and_return(100)
    pin.scale
    pin.scale.should eql(100)
  end

  context "private methods: " do
    it "sets default_io" do
      BBB::Pins::IO::AIN.should_receive(:new)
      pin.send(:default_io)
    end
  end

end
