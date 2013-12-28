module BBB
  module Pins
    ##
    # A pin that reads from the ADC converteds on the board. On the Beaglebone
    # this is AIN1 to 7. The class itself doesn't do much, since most of the
    # basic functionality is provided by the pinnable module which is included,
    # as well as the IO::AIN object used for IO to the filesystem
    #
    class AnalogPin
      include Pinnable

      ##
      # Read from the Pin
      #
      # @return Integer
      #
      def read
        io.read
      end

      ##
      # Return the scale of the Pin. On the BeagleBoneBlack 12 bit pins this is
      # 4096.
      #
      # @return Integer
      #
      def scale
        @scale ||= io.scale
      end

      private

      def default_io
        IO::AIN.new(position)
      end

    end
  end
end
