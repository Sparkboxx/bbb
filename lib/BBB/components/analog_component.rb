module BBB
  module Components
    class AnalogComponent
      include Pinnable

      attr_reader :pin, :pins

      def initialize
        @pin = BBB::Pins::AnalogPin
        @pins = [@pin]
      end

      def read
        pin.read
      end

      def value
        read
      end
    end
  end
end
