require 'spec_helper'

describe BBB::Components::Servo do
  let(:servo) { BBB::Components::Servo }

  it "initializes with a pin as options" do
    s = servo.new(:pin=>:P8_13)
    s.positions.should eql([:P8_13])
  end

  %w(period min_duty max_duty max_degrees).each do |method|
    it "#{method} as option" do
      s = servo.new(method.to_sym=>123)
      s.send(method.to_sym).should eql(123)
    end
  end

  context "after initialization" do
    before :each do
      @servo = servo.new
      @pin = double(BBB::Pins::PWMPin)
      allow(@servo).to receive(:pin).and_return(@pin)
    end

    it "sets the period, duty and run" do
      %w(period duty run).each do |method|
        @pin.should_receive("#{method}=".to_sym)
      end
      @servo.send(:after_pin_initialization)
    end
  end

  context "setting angles" do
    before :each do
      @servo = servo.new
      @pin = double("pin")
      allow(@servo).to receive(:pin).and_return(@pin)
      allow(@pin).to receive(:"duty=")
    end

    it "#angle calls pin.duty" do
      @pin.should_receive(:"duty=")
      @servo.angle(100)
    end

    it "#angle converts angle to duty" do
      @servo.should_receive(:degrees_to_ns).with(100)
      @servo.angle(100)
    end
  end

end
