module BBB
  ##
  # The idea here is to attach a piece of equipment to a circuit.
  #
  # A component (e.g. Led or Servo) will define generic pins, like
  # DigitalInput or AnalogOutput. And then, when the component gets connected to
  # the circuit those pins will be initialized using the file system.
  #
  # For now the attachment will be made onto specific pin numbers. For the BBB
  # this might for example be :P8_3, however, the plan is to, in a future
  # release, make sure that there are converters between the different kind of
  # boards. For example by mapping P8_3 on BBB to P1 on an Arduino.
  #
  class Circuit
    attr_reader :options

    include Attachable
    include Components

    def initialize(options={})
      @options = options
    end
  end
end
