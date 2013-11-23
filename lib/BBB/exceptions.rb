module BBB
  class UnknownPinException < ArgumentError; end
  class UnknownPinModeException < ArgumentError; end
  class PinsDoNotMatchException < ArgumentError; end
  class NotImplementedError < ArgumentError; end
end
