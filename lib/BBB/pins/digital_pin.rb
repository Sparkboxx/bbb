module BBB
  module Pins
    ##
    # A Digital Pin on the board. The digital pins uses GPIO on the filesystem
    # to communicate. This class assumes its the only actor on the pin. Therfore
    # it can cache the status in memory instead of reading it from the
    # filesystem every time.
    #
    # It is advised to use the DigitalInputPin and DigitalOutputPin classes for
    # clarity, buy, nothings stops you from using a DigitalPin with the :input
    # or :output direction.
    #
    class DigitalPin
      include Pinnable

      attr_reader :status, :opts

      ##
      # Gets the direction of the pin from the options and memoizes it in the
      # @direction attribute.
      #
      # @return [Symbol] either :input or :output
      def direction
        @direction ||= @opts.fetch(:direction)
      end

      ##
      # Write value to the specified pin Digitally. This might fail hard if you
      # try to write to an input pin. However, for performance reasons we do not
      # want to check the direction of the pin every write.
      #
      def write(value)
        @status = value
        io.write(value)
      end

      ##
      # Read value from the pin for input pins, or from memory for output pins.
      #
      # @return [Symbol] :high or :low
      #
      def status
        if direction == :input
          @status = io.read
        end

        return @status
      end

      ##
      # Set the pin into :high state
      # @return [void]
      def on!
        write(:high)
      end

      ##
      # Set the pin into :low state
      # @return [void]
      def off!
        write(:low)
      end

      ##
      # Check if the pin state is high
      # @return [Boolean]
      def on?
        status == :high
      end

      ##
      # Check if the pin state is low
      # @return [Boolean]
      def off?
        !on?
      end

      private

      def default_io
        IO::GPIO.new(direction, position)
      end
    end

    ##
    # @see DigitalPin
    #
    class DigitalInputPin < DigitalPin
      def initialize(position, opts={})
        opts.merge!(:direction=>:input)
        super(position, opts)
      end
    end

    ##
    # @see DigitalPin
    #
    class DigitalOutputPin < DigitalPin
      def initialize(position, opts={})
        opts.merge!(:direction=>:output)
        super(position, opts)
      end
    end

  end
end
