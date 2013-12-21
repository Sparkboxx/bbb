module BBB
  module Components
    class Servo
      include Pinnable

      attr_reader :pin, :pins

      def initialize
        @pin = BBB::IO::PWMPin.new
        @pins = [@pin]
        after_attachment_callback
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
