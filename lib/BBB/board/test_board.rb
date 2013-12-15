module BBB
  module Board
    class TestBoard < BBB::Board::Base

      private

      def self.pin_converter
        GPIO::PinConverter.new(mock:true)
      end
    end
  end
end
