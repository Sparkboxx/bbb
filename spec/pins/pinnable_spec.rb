require 'spec_helper'

describe BBB::Pins::Pinnable do
  class MockPin
    include BBB::Pins::Pinnable
  end

  let(:pin) { MockPin.new(:P8_13) }

  it "returns true to pinnable?" do
    pin.pinnable?.should be_true
  end

  context "initialization" do
    it "sets @position" do
      pin.position.should eql(:P8_13)
    end

    it "sets @opts" do
      pin = MockPin.new(:P8_13, foo: "bar")
      pin.opts.should eql({foo: "bar"})
    end
  end


  context "mocking" do
    it "sets mock when initialized with mock" do
      pin = MockPin.new(:P8_13, mock: true)
      pin.mock?.should be_true
    end

    it "sets no mock when not initialized with mock" do
      pin = MockPin.new(:P8_13, mock: false)
      pin.mock?.should be_false

      BBB.escape_test do
        pin = MockPin.new(:P8_13)
        pin.mock?.should be_false
      end
    end
  end

  context "io" do
    it "mock_io when mock given" do
      pin = MockPin.new(:P8_13, mock: true)
      pin.io.kind_of?(StringIO).should be_true
    end

    it "default_io when no mock given" do
      lambda do
        pin = MockPin.new(:P8_13, mock: false)
        pin.io
      end.should raise_error(NotImplementedError)
    end
  end

  context "private methods" do
    it "raises error on #default_io" do
      lambda do
        pin.send(:default_io)
      end.should raise_error(NotImplementedError)
    end

    it "returns StringIO on #mock_io" do
      StringIO.should_receive(:new).and_return("foo")
      pin.send(:mock_io).should eql("foo")
    end
  end

end
