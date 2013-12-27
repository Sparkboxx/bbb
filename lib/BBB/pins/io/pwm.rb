module BBB
  module Pins
    module IO
      class PWM
        attr_reader :handles

        def initialize(position)
          self.export
          @handles = get_file_handles
        end

        def pin_map(position)
          return @pin_map unless @pin_map.nil?
          map = PinMapper.map(position, :pwm)
          unless map.respond_to?(:pwm) && !map.pwm.nil?
            raise ArgumentError, "#{position} is not a valid PWM pin position"
          end

          @pin_map = map
        end

        def pwm_path
          return @pwm_path unless @pwm_path.nil?
          @pwm_path = Dir.glob("/sys/devices/ocp.*/pwm_test_#{pin_map.key}.*")
        end

        def get_file_handles
          handles = {}
          files = %w(duty, period, polarity, run)

          files.each do |file|
            file_path = File.expand_path(file, pwm_path)
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
          system("echo bone_pwm_#{pin_map.key} > #{dir}")
        end

        def write(symbol, value)
          handle = file_handles[:duty]
          handle.rewind
          handle.write(value)
          handle.flush
          return value
        end

        def read(symbol)
          handle = handles[symbol]
          handle.rewind
          handle.read
        end
      end
    end
  end
end

