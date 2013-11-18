require 'spec_helper'

describe BBB::PinMapper do
  let(:mapper) { BBB::PinMapper }

  it "should be able to map" do
    mapper.map(:P8_3).should eql(38)
  end

  it "should upcase" do
    mapper.map(:p8_3).should eql(38)
  end

  it "should raise an error when requesting an unknown pin" do
    lambda{ mapper.map(:P10_1) }.should raise_exception(BBB::UnknownPinException)
  end
end
