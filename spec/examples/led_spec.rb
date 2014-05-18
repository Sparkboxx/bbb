require 'spec_helper'

describe "Blinking a Led" do

  ##
  # Setup the actual Application
  #
  class LedExampleApplication < BBB::Application
    # Connect the led
    attach BBB::Components::Led, as: :led

    def initialize
      led.connect(:P8_10, mock: true)
    end

    # This is the basic run loop
    def run
      led.on!  # this does what you think it does
      sleep(1) # sleep for 1 second, kind of blunt, since it blocks everthing.
      led.off!
      sleep(1)
    end
  end

  # Initialize and run the LedExampleApplication

  it "should initialize" do
    lambda{ LedExampleApplication.new}.should_not raise_error
  end

  it "should respond to led" do
    app = LedExampleApplication.new
    app.respond_to?(:led).should be_true
  end

  it "should be able to turn led on" do
    app = LedExampleApplication.new
    lambda {app.led.on!}.should_not raise_error
  end
end
