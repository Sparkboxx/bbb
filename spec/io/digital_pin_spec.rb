require 'spec_helper'

describe BBB::IO::DigitalPin do
  it "should initialize" do
    lambda do
      BBB::IO::DigitalPin.new(:P8_2)
    end.should_not raise_exception
  end
end
