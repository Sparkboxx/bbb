module BBB
  class UnknownPinException < ArgumentError; end
  class UnknownPinModeException < ArgumentError; end
  class PinsDoNotMatchException < ArgumentError; end
end
