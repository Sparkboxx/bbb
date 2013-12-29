module BBB
  module Pins
    module IO
      class PWM
        include Mapped

        attr_reader :handles

        def initialize(position)
          self.export
          @handles = get_file_handles
        end

        def path
          return @path unless @path.nil?
          @path = Dir.glob("/sys/devices/ocp.*/pwm_test_#{pin_map.key}.*")
        end

        def get_file_handles
          handles = {}
          files = %w(duty, period, polarity, run)

          files.each do |file|
            file_path = File.expand_path(file, path)
            handles[file.to_sym] = File.open(file_path, "w")
          end

          return handles
        end

        def export
          cape_dir = "/sys/devices/bone_capemgr.*/slots"
          dir = Dir.glob(cape_dir)
          if dir.length == 0
            raise BoardError, "unable to access the capemgr directory: #{cape_dir}"
          end
          system("echo am33xx_pwm > #{dir}")
          system("echo bone_pwm_#{pin_map.key} > #{dir}")
        end

        def write(symbol, value)
          handle = file_handles[symbol]
          handle.rewind
          handle.write(value)
          handle.flush
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

