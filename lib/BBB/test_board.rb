module BBB
  class TestBoard < BBB::Board

    private

    def self.pin_converter
      GPIO::PinConverter.new(mock:true)
    end
  end
end

