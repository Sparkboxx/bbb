require 'spec_helper'

describe BBB::IO::PWMPin do
  let(:pin) { BBB::IO::PWMPin.new }

  it "should initialize" do
    lambda do
      BBB::IO::PWMPin.new
    end.should_not raise_exception
  end

  it "should respond to register_position" do
    pin.respond_to?(:'position=').should be_true
  end

end
