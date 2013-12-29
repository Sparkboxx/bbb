module BBB
  module Components
    class Servo
      include Pinnable
      uses Pins::PWMPin

      attr_reader :min, :max, :period

      def after_pin_initialization
        pin.period = 17e9
        pin.duty   = (min + range / 2).to_i
        pin.run    = 1
      end

      def write(degrees)
        value = degrees.to_f / 360.to_f * range + min
        pin.write(value)
      end

      def pin
        pins.first
      end

      def min
        14.6e6.to_i
      end

      def max
        16.6e6.to_i
      end

      def range
        max-min
      end

    end
  end
end
