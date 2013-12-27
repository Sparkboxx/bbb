module BBB
  module Components
    class Servo
      include Pinnable

      attr_reader :pin, :pins

      def initialize
        @pin = BBB::Pins::PWMPin
        @pins = [@pin]
      end

      def after_attachment_callback
        pin.duty=""
        pin.period=""
        pin.polarity=""
        pin.run=""
      end

      def write(degrees)
        pin.write
      end
    end
  end
end
