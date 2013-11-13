module BBB
  module Components
    module Pinnable
      attr_reader :pins

      def register_pin_positions(*positions)
        pins.each_with_index do |pin, index|
          pin.position=positions[index]
        end
      end

    end
  end
end
