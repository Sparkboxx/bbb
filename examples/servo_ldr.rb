require 'BBB'

##
# An application where you mount an LDR to a servo. The servo will then turn
# towards the light. The idea for this application is that you, for example, use
# a servo to steer a small robot. When you then mount an LDR to the front of the
# robot, it will drive towards the light.
#
# The light finding algorithm could be much more sophisticaded, using several
# past measurements etc. etc. But you probably get the gist. Try for example to
# implement changes in the step_size over time.
#
#
class LDRServo < BBB::Application
  attr_accessor :angle
  attr_writer :previous_value

  attr_reader :direction

  attach Servo, as: :servo
  attach AnalogComponent, as: :ldr

  def initialize
    servo.connect(:P8_13)
    ldr.connect(:P9_40)
  end

  def run
    current_value = ldr.read

    ##
    # This means we're moving away from the lightest point.
    # So reverse.
    #
    if current_value < previous_value
      reverse_direction
    end

    ##
    # If the previous value is identical to the current_value we actually
    # might've found the brightest spot, so keep on going where you're going.
    # However, let's say the robot is in a dark room, and you turn on the lights
    # above, and the whole room has equal light. If at that moment, the servo is
    # positioned at an angle, it'll keep on making rounds.
    #
    # If you use this example to drive a robot, you're most probably driving at
    # an angle, which means the value will change and the robot will start
    # correcting itself. Reducing the angle, untill you're driving straigt to
    # the light. (or at least a local optimum)
    #
    #require 'pry'; binding.pry
    unless current_value == previous_value
      self.angle = angle + (step * direction)
      servo.angle(angle)
    end

    previous_value = current_value

    return nil
  end


  ##
  # In this example we use a static step of 2 degrees. Which allows for smooth
  # movement when making small adjustment, and still it's quite fast when having
  # to make large adjustments.
  #
  # It could be interesting to play with the step size depending op previous
  # measurements.
  #
  def step
    2
  end

  ##
  # Basic servo's can move about 120 degrees. So we'll initialize the angle to
  # 60 degrees. Which is probably straight ahead on a moving robot.
  #
  def angle
    @angle ||= 60
  end

  ##
  # Make sure the angle doesn't go out of the servo range. If it does, set it to
  # the minimum (0) or the maximum (120)
  #
  def angle=(value)
    if(0..120).include?(value)
      @angle = value
    else
      @angle = value > 0 ? max_servo_angle : min_servo_angle
    end
  end

  ##
  # We define 1 as going to the right, and -1 as going to the left.
  # Combined with a positive step this means that if the direction is 1, we're
  # moving more towards the right, and -1 we're moving more towards the left.
  #
  # (you can also read up/ down here instead of left / right, it all depends on
  # the way you mount your servo)
  #
  def direction
    @direction ||= 1
  end

  def reverse_direction
    @direction = direction * -1
  end

  def previous_value
    @previous_value ||= ldr.read
  end

  def min_servo_angle
    @min_servo_angle ||= 0
  end

  def max_servo_angle
    @max_servo_angle ||= 120
  end

end

LDRServo.new.start if __FILE__ == $0
