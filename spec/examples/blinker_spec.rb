require 'spec_helper'
require_relative "../../examples/blinker"

describe Blinker do

  # Initialize and run the LedExampleApplication

  it "should respond to led" do
    app = described_class.new
    app.respond_to?(:led).should be_true
  end

  it "should be able to turn led on" do
    app = described_class.new
    lambda {app.led.on!}.should_not raise_error
  end
end
