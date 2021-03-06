module BBB
  module Pins
    module IO
      class PWM
        include Mapped
        include Cape

        attr_reader :handles, :position

        def initialize(position)
          @position = position
          self.export
          @handles = get_file_handles
        end

        def path
          return @path unless @path.nil?
          @path = Dir.glob("/sys/devices/ocp.*/pwm_test_#{pin_map.key}.*").first
        end

        def get_file_handles
          handles = {}
          files = %w(duty period polarity run)

          files.each do |file|
            file_path = File.expand_path(file, path)
            f = File.open(file_path, "r+")
            f.sync = true
            handles[file.to_sym] = f
          end

          return handles
        end

        def export
          pin_map_key = pin_map.key # This calls the pin map, which raises an error in case pin can't be mapped.

          system("echo am33xx_pwm > #{cape_dir}")
          system("echo bone_pwm_#{pin_map_key} > #{cape_dir}")
          sleep(0.2) # This seems to be necessary for te driver to load
        end

        def write(symbol, value)
          handle = handles[symbol]
          handle.rewind
          begin
            handle.write(value)
          rescue Errno::EINVAL
            puts "Could not write the value #{value} to the handle #{symbol}"
          end
          return value
        end

        def read(symbol)
          handle = handles[symbol]
          handle.rewind
          handle.read.to_i
        end
      end
    end
  end
end

