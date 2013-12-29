module BBB
  module Components
    class Servo
      include Pinnable
      #uses Pins::PWMPin
      attr_reader :min_duty, :max_duty, :period

      def initialize(period=17e6, min_duty=14.6e6, max_duty=16.6e6)
        @period   = period
        @min_duty = min_duty
        @max_duty = max_duty
      end

      def after_pin_initialization
        pin.period = 17e6
        pin.duty   = (min_duty + duty_range / 2)
        pin.run    = 0
      end

      def angle(degrees)
        value = degrees / 180.to_f * duty_range + min_duty
        pin.duty = value
      end

      def activate!
        pin.run = 1
      end

      def deactivate!
        pin.run = 0
      end

      def pin
        pins.first
      end

      def duty_range
        max_duty - min_duty
      end

    end
  end
end
