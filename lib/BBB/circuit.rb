module BBB
  ##
  # The idea here is to attach a piece of equipment to a circuit. The circuit
  # will later be connected to a board.
  #
  # A component (e.g. Led or Servo) will define generic pins, like
  # DigitalInput or AnalogOutput. And then, when the circuit gets attached to
  # the board those pins will be "connected" to their "physical" counterparts
  # on the board.
  #
  # This allows you to develop generic circuits that can be attached to any
  # board. At least, in theory :-)
  #
  # For now the attachment will be made onto specific pin numbers. For the BBB
  # this might for example be :P8_1, however, the plan is to, in a future
  # release, make sure that there are converters between the different kind of
  # boards.
  #
  # As of now, the act of "attaching" something onto the circuit equals
  # setting up a component with generic pins.
  #
  class Circuit
    attr_reader :components

    def initialize
      @components = {}
    end

    ##
    # Attach a component of a certain type to the circuit
    #
    # @param component [Class] The class of the object you # want to attach.
    # @param opts [Hash] Hash of options that setup the component
    #
    # @option opts [Array<Symbol>] :pins The list of pin numbers used on the
    # circuit.
    #
    def attach(component, opts={})
      if component.kind_of?(Class)
        component = component.new
      end

      if pin_positions = opts[:pins]
        component_pins = component.pins
        verify_pin_argument_count(component_pins.count, pin_positions.count)
        component.register_pin_positions(pin_positions)
      end
    end

    def verify_pin_argument_count(type_count, position_count)
      if types_count != positions_count
        raise PinsDoNoMatchException,
          "#{object.to_s} requires #{types_count} but received #{position_count} pin arguments."
      end

    end


  end
end
