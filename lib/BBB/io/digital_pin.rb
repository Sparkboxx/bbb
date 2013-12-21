module BBB
  module IO
    ##
    # Digital pin which is abstracted away from any kind of IO.
    # This has the benefit of being able to write a generic application
    # that you can then easily port to a BBB, Pi or Arduino
    #
    class DigitalPin
      include Pinnable
      attr_reader :mode, :status
      attr_accessor :pin_io

      ##
      # Initialize a digital pin.
      #
      # @param pin_num [Symbol]
      # @param mode [Symbol, nil] the mode of the pin, :input or :output. Defaults
      # to :input
      # @pin_io [IO, nil] the IO object
      #
      def initialize(mode=:input, pin_io=nil, position=nil)
        @pin_io = pin_io || MockPin.new
        @mode = mode
        @position = position
      end

      # Writes to the specified pin Digitally
      # accepts values :high or :low
      def write(value)
        raise ArgumentError unless [:high, :low].include?(value)
        @status = value
        @pin_io.write(value)
      end

      # Reads digitally from the specified pin on initialize
      def read
        if mode == :input
          pin_io.read
        else
          status
        end
      end

      # Sets digital write for the pin to HIGH
      def on!
        write(:high)
      end
      #
      # Sets digital write for the pin to LOW
      #
      def off!
        write(:low)
      end

      def on?
        (status == :high) ? true : false
      end

      def off?
        !self.on?
      end

    end
  end
end
