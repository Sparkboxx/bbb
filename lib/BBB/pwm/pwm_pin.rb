module BBB
  module PWM
    class PWMPin
      attr_reader :position, :pin_map, :mock
      attr_reader :file_handles

      def initialize(position, opts={})
        self.position = position
        @mock         = opts.fetch(:mock, false)
        @file_handles = get_file_handles(mock)
      end


      def position=(position)
        map = Board::PinMapper.map(position, :pwm)
        unless map.respond_to?(:pwm) && !map.pwm.nil?
          raise ArgumentError, "#{position} is not a valid PWM pin position"
        end

        @pin_map = map
        @position = position
      end

      def pwm_path
        @pwm_path ||= Dir.glob("/sys/devices/ocp.*/pwm_test_#{pin_map.key}.*")
      end

      def get_file_handles(mock=false)
        export unless mock

        handles = {}
        files = %w(duty, period, polarity, run)

        files.each do |file|
          if mock
            file_path = File.expand_path(file, pwm_path)
            handles[file.to_sym] = File.open(file_path, "w")
          else
            handles[file.to_sym] = StringIO.new
          end
        end

        return handles
      end

      def duty=(value)
        write(:duty, value)
      end

      def period=(value)
        write(:period, value)
      end

      def polarity=(value)
        write(:polarity, value)
      end

      def run=(value)
        write(:run, value)
      end

      def export
        dir = Dir.glob("/sys/devices/bone_capemgr.*/slots")
        `echo bone_pwm_#{pin_map.key} > #{dir}`
      end

      private

      def write(symbol, value)
        handle = file_handles[:duty]
        handle.rewind
        handle.write(value)
        handle.flush
      end

    end
  end
end
