module BBB
  module Components
    class AnalogComponent
      include Pinnable

      attr_reader :pin

      def initialize
        @pin = BBB::IO::AnalogPin.new
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
