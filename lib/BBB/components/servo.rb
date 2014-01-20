module BBB
  module Components
    class Servo
      include Pinnable
      uses Pins::PWMPin
      attr_reader :period, :min_duty, :max_duty, :max_degrees
      attr_reader :positions

      ##
      # Min duty and max duty for FS5103B servo
      # duty cycle of 900 to 2100 ms for 120 degrees
      # http://www.servodatabase.com/servo/feetech/fs5103b
      #
      def initialize(options={})
        @period   = options.fetch(:period, 20e6)
        @min_duty = options.fetch(:min_duty, 17.9e6)
        @max_duty = options.fetch(:max_duty, 19.1e6)
        @max_degrees = options.fetch(:max_degrees, 120)
        @positions = [options.fetch(:pin, nil)].compact
      end

      def after_pin_initialization
        pin.period = self.period
        pin.duty   = (min_duty + duty_range / 2)
        pin.run    = 1
      end

      def angle(degrees)
        pin.duty = degrees_to_ns(degrees)
      end

      def degrees_to_ns(degrees)
        degrees / max_degrees.to_f * duty_range + min_duty
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
