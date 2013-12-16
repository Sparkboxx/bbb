require 'BBB'

##
# Setup the LED Circuit
#
class Circuit < BBB::Circuit
  def initialize
    # Attach the led to pin P8_10
    attach BBB::Components::Led, pin: :P8_10, as: :led
  end
end

##
# Setup the actual Application
#
class LedExampleApplication < BBB::Application
  # Run this on the BeableBoneBlack
  board BBB::Board::Base.new

  # Connect the led circuit
  circuit Circuit.new

  # This is the basic run loop
  def run
    led.on!  # this does what you think it does
    sleep(1) # sleep for 1 second, kind of blunt, since it blocks everthing.
    led.off!
    sleep(1)
  end
end

# Initialize and run the LedExampleApplication
app = LedExampleApplication.new
app.start
