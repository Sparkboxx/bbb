module BBB
  module Components
    class ESC
      include Pinnable
      uses Pins::PWMPin

      attr_reader :positions

      attr_accessor :min_duty, :max_duty, :period
      attr_reader :duty

      def initialize(period=20e6, min_duty=17.5e6, max_duty=19e6, options={})
        @period   = period
        @min_duty = min_duty
        @max_duty = max_duty
        @positions = [options.fetch(:pins, nil)].compact
      end

      def after_pin_initialization
        self.disarm
        self.period = @period
        self.duty   = max_duty
      end

      def speed(value)
        self.duty = max_duty - value * self.duty_range
      end

      def calibrate
        pwm.run = 0
        puts "Disconnect the battery of the motor"; gets
        puts "Get ready to connect the battery after 2 seconds, ready?"; gets
        speed(1)
        pwm.run = 1
        puts "one missisipi"; sleep(1)
        puts "two missisipi"; sleep(1)
        puts "connect the battery"; sleep(1)
        speed(0)
        puts "Calibrated and ready to go"
      end

      def arm
        pwm.run=1
      end

      def armed?
        pwm.run == 1
      end

      def disarm
        pwm.run=0
      end

      def disarmed?
        !armed?
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
    end
  end
end
