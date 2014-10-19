# To run this example do this first:
#
# Make sure you run as root
# > sudo su
#
# Install BBB gem
# > gem install BBB
#
# Then activate the ADC using the cape
# > echo cape-bone-iio > /sys/devices/bone_capemgr.*/slots
#
# Now open up an IRB console and copy paste in this code
# > irb
#
# BE CAREFUL:
# The AIN pins only take 1.8V at max. So if you connect an output pin
# to an input pin make sure you use a voltage divider circuit. See here:
# http://learn.adafruit.com/setting-up-io-python-library-on-beaglebone-black/adc
#
require 'BBB'

##
# Setup the actual Application
#
class Thermometer < BBB::Application
  attach AnalogComponent, as: :thermometer

  def initialize
    thermometer.connect(:P9_40)
  end

  # This is the basic run loop
  def run
    print "value: #{thermometer.read}\r"
  end
end

# Initialize the app
Thermometer.new.start if __FILE__ == $0
