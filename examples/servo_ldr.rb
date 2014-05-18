require 'BBB'

class LDRServo < BBB::Application
  attr_accessor :min, :max

  attach Servo, as: :servo
  attach AnalogComponent, as: :ldr

  def initialize(min, max)
    @min = min
    @max = max
  end

  def activate_components
    servo.connect(:P8_13)
    ldr.connect(:P9_40)
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

app = LDRServo.new(0,180)
app.angle(120)

