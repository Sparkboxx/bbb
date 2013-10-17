require 'bbb'

module Thunderball
  class Copter << BBB::Application
    ##
    # Use the BBB as the board, allows for possible ports to e.g. the Pi
    #
    board  BBB::Board.new

    ##
    # Load the thunderball layout
    #
    layout Layout.new

    attr_reader :stabalizer, :mover

    def initialize
      @stabalizer = Stabalizer.new(escs: escs,
                                   gyro: gyro,
                                   accelerometer: acc)

      @mover = Mover.new(escs: escs)
    end

    ##
    # Once start is called the run function will be called in a loop
    #
    def run
      stabalizer
      move(:forward=>20, :right=>10)
    end

    ##
    # Stabalize function is just syntactic sugar to make the run method look nice.
    #
    def stabilize
      stabalizer.update
    end

    ##
    # move function is just syntactic sugar to make the run method look nice.
    #
    def move
      mover.update
    end
  end # Copter

  class Layout < BBB::Layout
    def initialize
      attach_escs
      attach_led
    end

    def attach_escs
      attach ESC, :pins=>[:P8_1, :P8_2], :as=>:esc_1
      attach ESC, :pins=>[:P9_1, :P9_2], :as=>:esc_2
    end

    def attach_leds
      attach Led.new(option: "foo",
                     option2: "bar"), :pin=>:P9_12
    end
  end # Layout

  class Mover
    def initialize(opts={})
      @escs = opts[:escs]
    end

    def move
      # Do some complex logic here with the escs
    end
  end # Mover

  def Stabalizer
    def initialize(opts={})
      @escs = opts[:escs]
      @gyo = opts[:gyro]
      @accelerometer = opts[:accelerometer]
    end

    def stabalize
      # Do someting complex with all the components
      # and update all values
    end
  end #Stabalizer
end

module BBB
  class Layout
    ##
    # include default components like Servo and Led
    #
    include Components

    ##
    # @param component [Object, Class] the component to attach. If an Object is
    # given it will attach is as is, if a class is given, a new instance of the
    # class will be attached.
    #
    # @param [Hash] The options for naming and pins
    # @option opts [Symbol]         :as           name of the component
    # @option opts [Array<Symbol>]  :pins         input pins for the component, alias of pins
    # @option opts [Array<Symbol>]  :input_pins   input pins for the component
    # @option opts [Array<Symbol>]  :output_pins  output pins for the component
    # @option opts [Symbol]         :group        place component in group
    #
    def attach(component, options)

    end
  end # Layout

  class Application
    board BBB::Board.new

    def initialize
    end

    def start
      loop do
        read
        run
        write
      end
    end

    def read
      board.read
    end

    def run
      raise NotImplementedError
    end

    def write
      board.write
    end

  end # Application

  class Board
    def read
      input_pins.each(&:read)
    end

    def write
      output_pins.each(&:write)
    end

    def setup(layout)

    end
  end # Board

  class Pin
    def self.factory(klass=:digital, type=:output, opts={})
      const = "#{klass.capitalize}::#{type.capitalize}"
      const_get(const).new(opts)
    end

    class Digital

      class Pin
        attr_reader :value

        def initialize(opts={})
        end
      end

      class Input < Pin
        def read
        end

        def high?
          value == 1
        end

        def low?
          value == 0
        end
      end

      class Output < Pin
        def write
        end

        def high
          value = 1
        end

        def low
          value = 0
        end

        private

        def value=(value)
          @value = value
        end
      end

    end
  end

  module Components
    class Component
      attr_accessor :input_pins, :output_pins, :input_pin

      ##
      # Set the readers and writers of the component
      # @param [Hash] The options for the input and output pins
      # @option opts [Array<Symbol>]  :pins         input pins for the component, alias of pins
      # @option opts [Array<Symbol>]  :input_pins   input pins for the component
      # @option opts [Array<Symbol>]  :output_pins  output pins for the component
      #
      def attach(opts={})
        opts.each do |key, value|
          send("#{key}=".to_sym, value)
        end
      end

      def pins=(pins)
        input_pins = pins
      end

      def pin=(pin)
        input_pin = pin
      end
    end

    class Led < Component

      def on
        input_pin.high
      end

      def on?
        input_pin.high?
      end

      def off
        input_pin.low
      end

      def off
        input_pin.low?
      end

      def pins=(pins)
        input_pin = pins.first
      end

    end

    class Servo < Component; end
    class ESC < Servo; end
  end
end
