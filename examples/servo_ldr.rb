require 'BBB'

class Circuit < BBB::Circuit
  include BBB::Components

  def initialize
    attach Servo, pins: :P8_13, as: :servo
    attach AnalogComponent, pin: :P9_40, as: :ldr
  end
end

class LDRServo < BBB::Application
  attr_accessor :min, :max

  circuit Circuit.new

  def initialize(min, max)
    @min = min
    @max = max
  end

  def run
    servo.angle(angle)
  end

  def range
    max - min
  end

  def angle
    (ldr.value - min) / range.to_f * 180
  end

end
