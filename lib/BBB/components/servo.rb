module BBB
  module Components
    class Servo
      include Pinnable
      uses Pins::PWMPin

      attr_reader :min, :max, :period


      def initialize(min=1000, max=2000, period=20)
        @min, @max, @period = min, max, period
      end

      def after_pin_initialization
        pin.period = period * 1e9
        pin.duty   = (min + (max-min) / 2) * 1e6
        pin.run=0
      end

      def write(degrees)
        pin.write
      end

      def pin
        pins.first
      end

    end
  end
end
