module BBB
  module GPIO
    class Base
      attr_reader :position, :converted_position
      attr_reader :file_class

      def initialize(position=nil, opts={})
        initialize_base(position, opts)
      end

      def initialize_base(pin_position, opts)
        @mock = opts.fetch(:mock, false)
        self.position = pin_position
        @file_class = @mock ? StringIO : File
        export
      end

      def position=(position, mock=false)
        @position = position
        @converted_position = Board::PinMapper.map(position).gpio
      end

      def gpio_path
        "/sys/class/gpio"
      end

      def export_path
        gpio_path + "/export"
      end

      def unexport_path
        gpio_path + "/unexport"
      end

      def gpio_direction_input
        "in"
      end

      def gpio_direction_output
        "out"
      end

      def gpio_pin_dir
        "#{gpio_path}/gpio#{converted_position}"
      end

      def export
        file_class.open(export_path, "w") { |f| f.write("#{ converted_position }") }
      end

      def unexport
        file_class.open(unexport_path, "w") { |f| f.write("#{converted_position}") }
      end
    end
  end
end
