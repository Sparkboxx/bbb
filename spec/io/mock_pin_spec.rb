require 'spec_helper'

describe BBB::IO::MockPin do
  let(:pin) {BBB::IO::MockPin.new}

  it "responds to read" do
    pin.respond_to?(:read)
  end

  it "responds to write" do
    pin.respond_to?(:write)
  end
end
