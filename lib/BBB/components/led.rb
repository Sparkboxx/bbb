module BBB
  module Components
    class Led
      include Pinnable
      attr_reader :pin

      def initialize
        @pin = BBB::Pins::DigitalOutputPin
        @pins = [@pin]
      end

      def on!
        pin.on!
      end

      def off!
        pin.off!
      end

      def on?
        pin.on?
      end

      def off?
        pin.off?
      end

    end
  end
end
