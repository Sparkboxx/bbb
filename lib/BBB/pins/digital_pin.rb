module BBB
  module Pins
    class DigitalPin
      include Pinnable

      attr_reader :status

      def direction
        @direction ||= @opts.fetch(:direction)
      end

      # Writes to the specified pin Digitally
      # accepts values :high or :low
      def write(value)
        @status = value
        io.write(value)
      end

      def read
        mode == :input ? io.read : status
      end

      def on!
        write(:high)
      end

      def off!
        write(:low)
      end

      def on?
        status == :high
      end

      def off?
        status == :low
      end

      private

      def default_io
        IO::GPIO.new(direction, position)
      end
    end

    class DigitalInputPin < DigitalPin
      def initialize(position, opts={})
        opts.merge!(:direction=>:input)
        super(position, opts)
      end
    end

    class DigitalOutputPin < DigitalPin
      def initialize(position, opts={})
        opts.merge!(:direction=>:output)
        super(position, opts)
      end
    end

  end
end
