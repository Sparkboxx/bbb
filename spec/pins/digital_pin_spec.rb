require 'spec_helper'

describe BBB::Pins::DigitalPin do
  let(:input) { BBB::Pins::DigitalPin.new(:P8_4,
                                          direction: :input,
                                          mock: true)}
  let(:output) { BBB::Pins::DigitalPin.new(:P8_4,
                                          direction: :output,
                                          mock: true)}

  context "all pins" do
    it "includes pinnable" do
      input.pinnable?.should be_true
    end

    it "#direction gets memoized" do
      input.opts.should_receive(:fetch).with(:direction).once
        .and_return(:input)
      2.times do
        input.direction
      end

      input.direction.should eql(:input)
    end
  end

  context "input pins" do

    it "#status forwards to io" do
      input.io.should_receive(:read)
      input.status
    end

  end

  context "output pins" do

    it "#off! #on!" do
      output.off!
      output.off?.should be_true
      output.on?.should be_false

      output.on!
      output.on?.should be_true
      output.off?.should be_false
    end

    it "#on! #off!" do
      output.on!
      output.on?.should be_true
      output.off?.should be_false

      output.off!
      output.off?.should be_true
      output.on?.should be_false
    end

  end

  context "private methods: " do
    it "sets default_io" do
      BBB::Pins::IO::GPIO.should_receive(:new)
      input.send(:default_io)
    end
  end
end
