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
    puts thermometer.read
  end
end

# Initialize the app
app = TemperatureExampleApp.new
app.start
