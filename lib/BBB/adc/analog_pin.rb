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
        "/sys/devices/ocp.3/helper.15/AIN#{pin_map.ain}"
      end

      def read
        file_handle.read
      end

      def scale
        pin_map.scale
      end

      def get_file_handle(mock=false)
        mock ? StringIO.new : File.open(ain_path, "r")
      end

    end
  end
end
