module BBB
  module Pins
    class AnalogPin
      include Pinnable

      def read
        io.read
      end

      def scale
        io.scale
      end

      private

      def default_io
        IO::ADC.new(position)
      end

    end
  end
end
