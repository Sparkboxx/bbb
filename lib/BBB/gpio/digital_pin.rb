module BBB
  module GPIO
    class DigitalPin < Base
      attr_reader :mode

      def initialize(pin_num, mode)
        @pin_num = pin_num
        @mode = validate_mode(mode)
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
          "w"
        end
      end

      def set_mode
        direction_file = gpio_pin_dir + "/direction"
        file_class.open(direction_file, "w") {|f| f.write(direction)}
      end

      def io
        value_file     = gpio_pin_dir + "/value"
        return file_class.open(value_file, file_mode)
      end

      private

      def validate_mode(mode)
        if [:input, :output].include?(mode)
          return mode
        else
          raise UnknownPinModeException, "Pin mode: #{mode} is now known"
        end
      end


    end
  end
end
