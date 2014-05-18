require 'BBB'

##
# Setup the actual Application
#
class LedExampleApplication < BBB::Application
  # Connect the led
  attach BBB::Components::Led, as: :led

  def initialize
    led.connect(:P8_10)
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
app = LedExampleApplication.new
app.start
