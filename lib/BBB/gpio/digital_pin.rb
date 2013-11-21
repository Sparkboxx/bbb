module BBB
  module GPIO
    class DigitalPin < Base
      attr_reader :mode, :io

      def initialize(position, mode, opts={})
        initialize_base(position, opts)
        @mode = validate_mode(mode)
        set_mode
      end

      def direction
        case mode
        when :input
          gpio_direction_input
        when :output
          gpio_direction_output
        end
      end

      def file_mode
        case mode
        when :input
          "r"
        when :output
          "w+"
        end
      end

      def set_mode
        direction_file = gpio_pin_dir + "/direction"
        file_class.open(direction_file, "w") {|f| f.write(direction); f.flush}
      end

      def io
        return @io unless @io.nil?

        value_file     = gpio_pin_dir + "/value"
        @io = file_class.open(value_file, file_mode)
      end

      def write(value)
        io.rewind
        io.write value_map[value]
        io.flush
      end

      def read
	io.rewind
        value_map[io.read]
      end

      private

      def validate_mode(mode)
        if [:input, :output].include?(mode)
          return mode
        else
          raise UnknownPinModeException, "Pin mode: #{mode} is now known"
        end
      end

      def value_map
        @value_map ||= {:high=>1, :low=>0, 1=>:high, 0=>:low}
      end

    end
  end
end
