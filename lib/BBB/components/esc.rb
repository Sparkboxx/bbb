module BBB
  module Components
    class ESC
      include Pinnable
      uses Pins::PWMPin

      attr_accessor :min_duty, :max_duty, :period

      after_connect :setup_pin

      ##
      # Initialize a new ESC using default values for period, min_duty and
      #   max_duty if present. Please beware that at initialization stage there
      #   is no initialized PWM pin yet. So you can set the period and the
      #   min/max_duty instance variables, but not the variables on the pin.
      #   Only after "connecting" the esc to a board can you set the duty and
      #   period of the pin. Use the "after pin initialization" method for that.
      #
      def initialize(options={})
        set_options(options)

        @period = options.fetch(:period, 20e6)
        @speed  = 0

        @min_duty = options.fetch(:min_duty, 17.5e6)
        @max_duty = options.fetch(:max_duty, 19e6)
      end

      def speed(value)
        @speed = value
        @duty = max_duty - value * duty_range
        synchronize_duty
      end

      def calibrate
        pwm.run = 0
        puts "Disconnect the battery of the motor (press any key)"; gets
        puts "Get ready to connect the battery after 2 seconds, ready? (press any key)"; gets
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
        synchronize_duty
      end

      def period=(value)
        @period = value
        synchronize_period
      end

      def pwm
        pin
      end

      private

      def duty_range
        max_duty - min_duty
      end

      def synchronize_period
        pwm.period = @period
      end

      def after_pin_initialization
        disarm
        synchronize_period
        speed(0)
      end
    end
  end
end
