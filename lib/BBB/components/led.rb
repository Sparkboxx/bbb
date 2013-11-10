module BBB
  module Components
    class Led
      attr_reader :state, :pin

      def initialize
        @state = :low
        @pin = BBB::IO::DigitalPin.new(:output)
      end

      def on!
        pin.on!
        @state = :high
      end

      def off!
        pin.off!
        @state = :low
      end

      def on?
        state == :high
      end

      def off?
        state == :low
      end

    end
  end
end
