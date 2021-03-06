module BBB
  module Pins
    module IO
      class GPIO
        include Mapped

        attr_reader :file_mode, :converted_position, :position, :direction

        def initialize(direction, position)
          self.direction = direction
          @position = position
          @converted_position = pin_map.gpio
          self.export
        end

        def direction=(direction)
          @file_mode = direction == :input ? "r" : "w+"
          @direction = direction
        end

        def set_mode
          direction_file = gpio_pin_dir + "/direction"

          d = "in"  if direction == :input
          d = "out" if direction == :output

          file_class.open(direction_file, "w") {|f| f.write(d)}
        end

        def io
          return @io unless @io.nil?
          value_file = gpio_pin_dir + "/value"
          @io = file_class.open(value_file, file_mode)
          @io.sync = true

          return @io
        end

        def write(value)
          io.write(value_map[value])
        end

        def read
          io.rewind
          value_map.fetch(io.read.to_i)
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
          set_mode
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
