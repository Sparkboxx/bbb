require 'spec_helper'

describe BBB::IO::DigitalPin do
  let(:pin) { BBB::IO::DigitalPin.new }
  it "should initialize" do
    lambda do
      BBB::IO::DigitalPin.new
    end.should_not raise_exception
  end

  it "should respond to register_position" do
    pin.respond_to?(:'position=').should be_true
  end
end
