require 'spec_helper'

describe BBB::Application do

  it "initializes" do
    lambda { BBB::Application.new }.should_not raise_exception
  end

  class TestLedCircuit < BBB::Circuit
    attach BBB::Components::Led, as: :led
  end

  class TestConnectionApp < BBB::Application
    attach TestLedCircuit, as: :circuit
  end

  it "attaches virtual pins to board pins" do
    app = TestConnectionApp.new
    app.circuit.respond_to?(:led).should be_true
    app.circuit.led.respond_to?(:on!).should be_true
  end

  class FunctionsInApp < BBB::Application
    attach TestLedCircuit.new, as: :circuit

    def run
      raise StopIteration
    end
  end

  it "does run the re-implemented run method" do
    app = FunctionsInApp.new
    lambda{app.start}.should_not raise_error
  end

end
