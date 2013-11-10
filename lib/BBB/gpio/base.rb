module BBB
  module GPIO
    class Base
      attr_reader :pin_num, :file_class

      def initialize(pin_num=nil, opts={})
        initialize_base(pin_num, opts)
      end

      def initialize_base(pin_num, opts)
        @pin_num = pin_num
        @file_class = opts.fetch(:mock, false) ? StringIO : File
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
        "#{gpio_path}/gpio#{pin_num}"
      end

      def export
        file_class.open(export_path, "w") { |f| f.write("#{ pin_num }") }
      end

      def unexport
        file_class.open(unexport_path, "w") { |f| f.write("#{pin_num}") }
      end
    end
  end
end
