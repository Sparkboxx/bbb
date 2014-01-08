module BBB
  module Components
    class ESC
      include Pinnable
      uses Pins::PWMPin, Pins::DigitalOutputPin

      attr_accessor :min_duty, :max_duty, :period
      attr_reader :duty

      def initialize(period=20e6, min_duty=18e6, max_duty=19e6)
        @period   = period
        @min_duty = min_duty
        @max_duty = max_duty
      end

      def after_pin_initialization
        power.off!
        self.period = @period
        self.duty = min_duty
        pwm.run    = 1
      end

      def speed(value)
        self.duty = min_duty + value * self.duty_range
      end

      def duty=(value)
        @duty = value
        pwm.duty = @duty
      end

      def period=(value)
        @period = value
        pwm.period = value
      end

      def duty_range
        max_duty - min_duty
      end

      def pwm
        pins.first
      end

      def power
        pins.last
      end

    end
  end
end
