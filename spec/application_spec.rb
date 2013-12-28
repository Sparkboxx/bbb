require 'spec_helper'

describe BBB::Application do

  it "initializes" do
    lambda { BBB::Application.new }.should_not raise_exception
  end

  class TestLedCircuit < BBB::Circuit
    def initialize
      attach BBB::Components::Led, pin: :P8_3, as: :led
    end
  end

  class TestConnectionApp < BBB::Application
    circuit TestLedCircuit.new

    def run
      "yeah, this one!"
    end
  end

  it "attaches virtual pins to board pins" do
    app = TestConnectionApp.new

    app.circuit.respond_to?(:led).should be_true
    app.circuit.led.should_receive(:on!)

    app.led.should eql(app.circuit.led)
    app.led.on!
  end

  class FunctionsInApp < BBB::Application
    circuit TestLedCircuit.new

    def run
      raise StopIteration
    end
  end

  it "does run the re-implemented run method" do
    app = FunctionsInApp.new
    lambda{app.start}.should_not raise_error
  end

end
