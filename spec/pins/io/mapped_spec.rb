require 'spec_helper'

describe BBB::Pins::IO::Mapped do
  class MockIO
    include BBB::Pins::IO::Mapped
    attr_reader :position

    def initialize(position)
      @position = position
    end
  end

  it "maps GPIO pins" do
    m = MockIO.new(:P8_3)
    m.should_receive(:pin_map_key).and_return(:gpio)
    m.pin_map
  end

  it "maps AIN pins" do
    m = MockIO.new(:P9_40)
    m.should_receive(:pin_map_key).and_return(:ain)
    m.pin_map
  end


  it "maps PWM pins" do
    m = MockIO.new(:P9_14)
    m.should_receive(:pin_map_key).and_return(:pwm)
    m.pin_map
  end

  it "raises an argumenterror if a pin doesn't support the io type" do
    m = MockIO.new(:P8_1)
    m.should_receive(:pin_map_key).and_return(:pwm)
    lambda do
      m.pin_map
    end.should raise_error(ArgumentError)
  end

end

