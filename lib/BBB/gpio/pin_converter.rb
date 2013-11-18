module BBB
  module GPIO
    class PinConverter

      ##
      # Currently only converts IO::DigitalPins
      #
      def convert(pin, opts={})
        base_class = pin.class.to_s.split("::").last
        klass =  GPIO::const_get(base_class.to_sym)
        return klass.new(pin.position, pin.mode, opts)
      end

    end
  end
end
