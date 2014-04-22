module BBB
  module Attachable
    module ClassMethods

      def class_components
        @class_components ||= {}
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
      def attach(object, opts={})
        name   = opts.delete(:as)
        class_components[name] = object
        define_method_for_object(object, name)
      end

      def define_method_for_object(component, name)
        define_method(name) do
          value = components[name]
          return value if value

          object = self.class.class_components[name]
          value = object.kind_of?(Class) ? object.new : object

          components[name] = value
        end
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    def components
      @components ||= {}
    end

  end

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
    include Attachable
  end
end
