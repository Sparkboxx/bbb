require 'spec_helper'
require_relative '../../examples/analog_pin.rb'

describe Thermometer do

  it "has a thermometer" do
    described_class.new.respond_to?(:thermometer).should be_true
  end

  it "thermometer responds to read" do
    described_class.new.thermometer.respond_to?(:read).should be_true
  end
end
