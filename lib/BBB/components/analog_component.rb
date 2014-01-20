module BBB
  module Components
    ##
    # An AnalogComponent is a component that reads from an analog input (AIN) on
    # the board. You can use a generic analog component for, for example,
    # temperature or light sensors.
    #
    # The BeagleBoneBlack has 12 bit (4096) AIN pins. So the expected value of
    # an analog pin is between 0 and 4096.
    #
    class AnalogComponent
      include Pinnable

      attr_reader :positions

      uses BBB::Pins::AnalogPin

      def initialize(options={})
        @positions = [options.fetch(:pin, nil)].compact
      end


      ##
      # Read from an initialized pin, if the pins have not been initialized yet,
      # this method might actually raise an exception.
      #
      # @raise MethodNotFoundException
      #
      # @return Integer
      #
      def read
        pin.read
      end

      ##
      # @see #read
      #
      def value
        read
      end

      ##
      # Convenience method to grab the first pin in the pins array
      #
      # @return BBB::Pins::AnalogPin
      #
      def pin
        pins.first
      end
    end
  end
end
