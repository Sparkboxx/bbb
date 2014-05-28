require 'spec_helper'

describe BBB::Application do

  it "initializes" do
    lambda { BBB::Application.new }.should_not raise_exception
  end

  it "it responds to start" do
    BBB::Application.new.respond_to?(:start).should be_true
  end

  it "start calls run" do
    app = BBB::Application.new
    app.should_receive(:run).and_raise(StopIteration)
    app.start
  end

  it "run raises NotImplementedError" do
    app = BBB::Application.new
    lambda { app.run }.should raise_error(NotImplementedError)
  end

  class TestLedCircuit < BBB::Circuit
    attach Led, as: :led
  end

  class TestCircuitConnectionApp < BBB::Application
    attach TestLedCircuit, as: :circuit
  end

  it "attaches virtual pins to board pins" do
    app = TestCircuitConnectionApp.new
    app.circuit.respond_to?(:led).should be_true
    app.circuit.led.respond_to?(:on!).should be_true
  end

  class TestBasicApp < BBB::Application
    attach Led, as: :led
  end

  it "adds helper functions to applications" do
    app = TestBasicApp.new
    app.respond_to?(:led).should be_true
  end

  class FunctionsInApp < BBB::Application
    def run
      raise StopIteration
    end
  end

  it "does run the re-implemented run method" do
    app = FunctionsInApp.new
    lambda{app.start}.should_not raise_error
  end

end
