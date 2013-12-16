#
# To run this example do this first:
#
# Make sure you run as root
# > sudo su
#
# Install BBB gem version 0.0.9 or higher
# > gem install BBB
#
# Then activate the ADC using the cape
# > echo cape-bone-iio > /sys/devices/bone_capemgr.*/slots
#
# No open up an IRB console and copy paste in this code
# > irb
#
# BE CAREFUL:
# The AIN pins only take 1.8V at max. So if you connect an output pin
# to an input pin make sure you use a voltage divider circuit. See here:
# http://learn.adafruit.com/setting-up-io-python-library-on-beaglebone-black/adc
#
require 'BBB'

##
# Setup the AnalogPin Circuit
#
class Circuit < BBB::Circuit
  def initialize
    # Attach temperature sensor to pin P9_40
    attach BBB::Components::AnalogComponent, pin: :P9_40, as: :thermometer
  end
end

##
# Setup the actual Applicaiton
#
class TemperatureExampleApp < BBB::Application
  # Run this on the BeagleBoneBlack
  board BBB::Board::Base.new

  # Connect the circuit to the board
  circuit Circuit.new

  # This is the basic run loop
  def run
    puts "value: #{thermometer.read}\r"
  end
end

# Initialize the app
app = TemperatureExampleApp.new
app.start
