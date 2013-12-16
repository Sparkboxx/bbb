module BBB
  module GPIO
    class PinConverter
      attr_reader :mock

      def initialize(opts={})
        @mock = opts.fetch(:mock, false)
      end

      ##
      # Currently only converts IO::DigitalPins
      #
      def convert(pin, opts={})
        opts = {:mock=>mock}.merge(opts)

        base_class = pin.class.to_s.split("::").last
        if GPIO.const_defined?(base_class)
          klass = GPIO::const_get(base_class.to_sym)
          return klass.new(pin.position, pin.mode, opts)
        elsif ADC.const_defined?(base_class)
          klass = ADC::const_get(base_class.to_sym)
          return klass.new(pin.position, opts)
        end
      end

    end
  end
end
