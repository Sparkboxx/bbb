module BBB
  module ADC
    class AnalogPin
      attr_reader :position, :pin_map, :mock
      attr_reader :file_handle

      def initialize(position, opts={})
        self.position = position
        @mock         = opts.fetch(:mock, false)
        @file_handle  = get_file_handle(mock)
      end

      def position=(position)
        map = Board::PinMapper.map(position, :ain)
        unless map.respond_to?(:ain) && !map.ain.nil?
          raise ArgumentError, "#{position} is not a valid AIN pin position"
        end

        @pin_map = map
        @position = position
      end

      def ain_path
        dir = Dir.glob("/sys/devices/ocp.*/helper.*/")
        return File.expand_path("AIN#{pin_map.ain}", dir.first)
      end

      def read
        file_handle.rewind
        file_handle.read.to_i
      end

      def scale
        pin_map.scale
      end

      def get_file_handle(mock=false)
        unless mock
          export
          return File.open(ain_path, "r")
        else
          return StringIO.new
        end
      end

      def export
        dir = Dir.glob("/sys/devices/bone_capemgr.*/slots")
        `echo cape-bone-iio > #{dir}`
      end
    end
  end
end
