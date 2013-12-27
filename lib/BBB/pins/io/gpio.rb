module BBB
  module Pins
    module IO
      class GPIO
        attr_reader :direction, :file_mode

        def initialize(direction, position)
          self.direction = direction
          @converted_position = PinMapper.map(position).gpio
          self.export
        end

        def direction=(direction)
          @filemode  = direction == :input ? "r" : "w+"
          @direction = direction
        end

        def set_mode
          direction_file = gpio_pin_dir + "/direction"
          file_class.open(direction_file, "w") {|f| f.write(direction); f.flush}
        end

        def io
          return @io unless @io.nil?
          value_file = gpio_pin_dir + "/value"
          @io = file_class.open(value_file, file_mode)
        end

        def read
          io.rewind
          value_map[io.read]
        end

        def value_map
          @value_map ||= {:high=>1, :low=>0, 1=>:high, 0=>:low}
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

        def gpio_pin_dir
          "#{gpio_path}/gpio#{converted_position}"
        end

        def export
          file_class.open(export_path, "w") { |f| f.write("#{ converted_position }") }
        end

        def unexport
          file_class.open(unexport_path, "w") { |f| f.write("#{converted_position}") }
        end

        def file_class
          File
        end
      end
    end
  end
end
