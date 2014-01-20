module BBB
  ##
  # The idea here is to attach a piece of equipment to a circuit.
  #
  # A component (e.g. Led or Servo) will define generic pins, like
  # DigitalInput or AnalogOutput. And then, when the component gets attached to
  # the circuit those pins will be initialized using the file system.
  #
  # For now the attachment will be made onto specific pin numbers. For the BBB
  # this might for example be :P8_3, however, the plan is to, in a future
  # release, make sure that there are converters between the different kind of
  # boards. For example by mapping P8_3 on BBB to P1 on an Arduino.
  #
  class Circuit
    attr_reader :components, :mock

    def components
      @components ||= {}
    end

    def mock?
      @mock == true
    end

    ##
    # Attach a component of a certain type to the circuit
    #
    # @param component [Class] The class of the object you # want to attach.
    # @param opts [Hash] Hash of options that setup the component
    #
    # @option opts [Symbol] :pin The pin position for the component
    # @option opts [Array<Symbol>] :pins The list of pin numbers used on the
    #     circuit.
    # @options opts [Symbol] :as The name of the component
    #
    def attach(component, opts={})
      name          = opts.delete(:as)
      component     = component.new if component.kind_of?(Class)
      pin_positions = opts.delete(:pins) || [opts.delete(:pin)]
      pin_options   = {:mock=>self.mock?}.merge!(opts)

      component.connect(pin_positions, pin_options)
      define_method_for_component(component, name)
    end

    def define_method_for_component(component, name)
      components[name] = component
      eigenclass = class << self; self; end
      eigenclass.class_eval do
        define_method(name) do
          components[name]
        end
      end
    end

  end
end
