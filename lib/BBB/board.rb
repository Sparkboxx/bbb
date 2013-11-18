module BBB
  class Board
    attr_reader :gpio, :pin_converter

    def initialize(pin_converter=nil)
      @pin_converter = pin_converter || self.class.pin_converter
      @pins = {}
    end

    ##
    # Define methods for a GPIO::PIN
    #
    def setup_pin(pin)
      @pins[pin.position] = pin

      metaclass = class << self; self; end
      metaclass.class_eval do
        define_method("p#{pin.position.to_s[1..-1]}") do
          @pins[pin.position].read
        end

        define_method("p#{pin.position.to_s[1..-1]}=") do |value|
          @pins[pin.position].write value
        end if pin.mode == :output
      end
    end

    def connect_io_pin(pin)
      gpio_pin   = pin_converter.convert(pin)
      pin.pin_io = gpio_pin
      setup_pin(pin)
    end

    private

    def self.pin_converter
      GPIO::PinConverter.new
    end

  end
end
