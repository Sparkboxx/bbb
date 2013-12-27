module BBB
  module Components
    module Pinnable
      attr_reader :pins

      def initialize_pins(*positions, opts={})
        positions.flatten!
        verify_pin_position_count(positions.count)

        pins.each_with_index do |pin, index|
          pin = pin.new(position[index], opts)
        end
      end

      def verify_pin_position_count(position_count)
        if pins.count != position_count
          raise PinsDoNotMatchException,
            "#{self.class.to_s} requires #{pins.count} but received #{position_count} pin position."
        end
      end
    end
  end
end
