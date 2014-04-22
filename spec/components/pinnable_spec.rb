require 'spec_helper'

describe BBB::Components::Pinnable do
  class DummyPin
    include BBB::Pins::Pinnable
  end

  class DummyComponent
    include BBB::Components::Pinnable
    uses DummyPin
  end

  class DoubleDummyComponent
    include BBB::Components::Pinnable
    uses DummyPin, DummyPin
  end

  let(:dummy) { DummyComponent }
  let(:double_dummy) { DoubleDummyComponent }

  context "#connect" do
    it "with single position" do
      DummyPin.should_receive(:new).once.and_return(@mock_pin)
      c = dummy.new
      c.connect(:P8_3)
      c.pins[0].should eql(@mock_pin)
    end

    it "with single position and options" do
      DummyPin.should_receive(:new).with(:P8_3, {:key=>"value"}).once
        .and_return(@mock_pin)
      c = dummy.new
      c.connect(:P8_3, key: "value")
      c.pins[0].should eql(@mock_pin)
    end

    it "with multiple positions" do
      DummyPin.should_receive(:new).exactly(2).times.and_return(@mock_pin)
      c = double_dummy.new
      c.connect(:P8_3, :P8_4)
      c.pins[0].should eql(@mock_pin)
      c.pins[1].should eql(@mock_pin)
    end

    it "with multiple positions and options" do
      DummyPin.should_receive(:new).with(:P8_3, {:key=>"value"}).once
        .and_return(@mock_pin)
      DummyPin.should_receive(:new).with(:P8_4, {:key=>"value"}).once
        .and_return(@mock_pin)
      c = double_dummy.new
      c.connect(:P8_3, :P8_4, key: "value")
      c.pins[0].should eql(@mock_pin)
      c.pins[1].should eql(@mock_pin)
    end

    it "verifies the pin count" do
      c = dummy.new
      c.should_receive(:verify_pin_position_count).with([:P8_3])
      c.connect(:P8_3)
    end
  end

  context "#verify_pin_position_count" do

    it "raises exception when counts don't match" do
      c = dummy.new
      lambda do
        c.verify_pin_position_count([:foo, :bar])
      end.should raise_exception(BBB::PinsDoNotMatchException)
    end

    it "does not raise an exception when counts do match" do
      c = dummy.new
      lambda do
        c.verify_pin_position_count([:foo])
      end.should_not raise_exception
    end
  end

  it "should respond to pinnable?" do
    c = dummy.new
    c.pinnable?.should be_true
  end

  context "callbacks" do
    context "after_connect" do
      it "should use send on function name" do
      end

      it "should call if given a proc" do
      end
    end
  end
end
