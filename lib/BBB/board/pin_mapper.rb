module BBB
  module Board
    class PinMapper
      ##
      # Thanks to BoneScript, see the resources/pin_mappings.json.comment
      # for reference to the original BoneScript file.
      #
      MAP = JSONPinMapper.convert("resources/pin_mappings.json")

      def self.map(pin_symbol, type=:gpio)
        begin
          MAP.pins.fetch(pin_symbol.upcase.to_sym)
        rescue Exception => e
          raise UnknownPinException, "Pin #{pin_symbol} could not be mapped"
        end
      end
    end
  end
end
