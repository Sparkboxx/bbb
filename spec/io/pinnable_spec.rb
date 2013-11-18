require 'spec_helper'

describe BBB::IO::Pinnable do
  class TestPin
    include BBB::IO::Pinnable
  end

  it "registers positions" do
    pin = TestPin.new
    pin.position=:P8_3
    pin.position.should eql(:P8_3)
  end
end
