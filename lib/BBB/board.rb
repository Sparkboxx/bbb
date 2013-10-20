module BBB
  class Board
    attr_reader :gpio

    def initialize(gpio=nil)
      @gpio = gpio || self.class.default_gpio
      @pins = {}
    end

    def setup_pin(pin)
      metaclass = class << self; self; end
      metaclass.class_eval do
        define_method("pin#{pin.address.to_s[1..-1]}") do
          @pins[pin.address].value
        end

        define_method("pin#{pin.address.to_s[1..-1]}=") do |value|
          @pins[pin.address].value=value
        end if pin.type == :output
      end
      @pins[pin.address] = pin
    end

    private

    def self.default_gpio
      GPIO::Base.new
    end

  end
end
