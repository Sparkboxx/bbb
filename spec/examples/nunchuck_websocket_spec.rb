require 'spec_helper'
require_relative '../../examples/nunchuck_websocket'


describe NunchuckService do

  it "initializes" do
    lambda { described_class.new }.should_not raise_error
  end

end


describe NunchuckServer do

  it "initializes" do
    lambda { described_class.new }.should_not raise_error
  end

end
