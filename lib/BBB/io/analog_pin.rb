module BBB
  module IO
    class AnalogPin
      include Pinnable

      attr_reader :pin_io, :position
      attr_accessor :pin_io

      def initialize(pin_io=nil, position=nil)
        @pin_io = pin_io || MockPin.new
        @position = position
      end

      def read
        pin_io.read
      end

      def scale
        pin_io.scale
      end

    end
  end
end
