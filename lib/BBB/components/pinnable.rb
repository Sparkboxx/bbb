module BBB
  module Components
    module Pinnable
      attr_reader :pins

      module ClassMethods
        ##
        # Register the use of classes of pins to a class. These classes will be
        # initialized upon #initialize_pins
        #
        # @param pin_classes [Array<Class>] the classes to register on class
        #   level.
        #
        def uses(*pin_classes)
          pins.concat(pin_classes)
        end

        ##
        # Attribute reader to the class level @pins
        #
        # @return Array<Class>
        #
        def pins
          @pins ||= []
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

      ##
      # Initialize the pin classes with their positions and options. Turning
      # them from their Classes into working pin instances.
      #
      # The argument list of the methods is a bit odd. Since it's not
      # possible to have both a splat and an option array as arguments, the
      # method signature only shows a splat of positions. The options are then
      # taken out of the positions, if the last position is actually a Hash as
      # opposed to a Symbol. If the last element of the positions list is not
      # a Hash, the options are set to an empty hash.
      #
      # @param positions [Array<Symbol>] positions the pins should be
      #   initialized with.
      # @param opts [Hash] Options to pass along to the pins during
      #   initialization.
      #
      # @return Array[Pins]
      #
      def initialize_pins(*positions)
        positions = self.positions if positions.empty?

        positions.flatten!
        opts = positions.last.kind_of?(Hash) ? positions.pop : {}

        verify_pin_position_count(positions)

        @pins = []
        self.class.pins.each_with_index do |pin, index|
          @pins << pin.new(positions[index], opts)
        end
        after_pin_initialization
      end

      ##
      # Verifies if the number of pins registered in the @pins array match with
      # the number of pins provided as an argument to the method. This function
      # normally gets called as part of the initialize pins method to verify if
      # the positions given to the initialize_pins method matches the number of
      # registered pins.
      #
      # @param positions [Array<Symbol>] The array of positions
      #
      # @raise [PinsDoNotMatchException] If the pin counts between the positions
      #   provided as an argument and the pins in the pins array do not match,
      #   this exception gets raised, to prevent hard to debug situations later
      #   on in the lifecycle of an application.
      #
      # @return Void
      def verify_pin_position_count(positions)
        if self.class.pins.count != positions.count
          raise PinsDoNotMatchException,
            "#{self.class.to_s} requires #{self.class.pins.count} but received #{positions.count} pin position."
        end
      end

      ##
      # Method which classes can overwrite to hook into the after pin
      # initialization
      #
      def after_pin_initialization
      end

      ##
      # Method that is used in the test suite to test if the pinnable module is
      # included in an object
      #
      # @return true
      def pinnable?
        true
      end
    end
  end
end
