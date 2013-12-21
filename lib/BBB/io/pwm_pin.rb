module BBB
  module IO
    class PWMPin
      include Pinnable
      attr_accessor :pin_io


      def initialize(pin_io=nil, position=nil)
        @pin_io = pin_io || MockPin.new
        @position = position
        after_attachment
      end

      def duty=(value)
        pin_io.duty = value
      end

      def period=(value)
        pin_io.period = value
      end

      def polarity=(value)
        pin_io.polarity = value
      end

      def run=(value)
        pin_io.run = value
      end
    end
  end
end

