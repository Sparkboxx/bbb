module BBB
  module Components
    module Pinnable
      attr_reader :pins
      attr_reader :positions

      module ClassMethods
        ##
        # Register the use of classes of pins to a class. These classes will be
        # initialized upon #connect
        #
        # @param classes [Array<Class>] the classes to register on class
        #   level.
        #
        def uses(*classes)
          pin_classes.concat(classes)
        end

        ##
        # Attribute reader to the class level @pins
        #
        # @return Array<Class>
        #
        def pin_classes
          @pin_classes ||= []
        end

        ##
        # Register callbacks
        #
        def after_connect(callback)
          after_connect_callbacks << callback
        end

        ##
        # Convenience function on class level that holds the callbacks (anything
        # that responds to call OR a symbol) that need to be called after the
        # pins get connected.
        #
        def after_connect_callbacks
          @after_connect_callbacks ||= []
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
      def connect(*positions)
        positions = self.positions if positions.empty?

        positions.flatten!
        opts = positions.last.kind_of?(Hash) ? positions.pop : {}

        verify_pin_position_count(positions)

        @pins = []
        self.class.pin_classes.each_with_index do |pin, index|
          @pins << pin.new(positions[index], opts)
        end
        after_connect_callbacks
        return self # so that we can chain it with the initializer
      end

      alias_method :pin_initialization, :connect

      ##
      # Verifies if the number of pins registered in the @pins array match with
      # the number of pins provided as an argument to the method. This function
      # normally gets called as part of the initialize pins method to verify if
      # the positions given to the connect method matches the number of
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
        if self.class.pin_classes.count != positions.count
          fail PinsDoNotMatchException,
            "#{self.class.to_s} requires #{self.class.pin_classes.count} but received #{positions.count} pin position."
        end
      end

      def after_connect_callbacks
        self.class.after_connect_callbacks.each do |callback|
          if callback.responds_to?(:call)
            callback.call
          else
            self.send(callback)
          end
        end
      end

      ##
      # Method that is used in the test suite to test if the pinnable module is
      # included in an object
      #
      # @return true
      #
      def pinnable?
        true
      end

      ##
      # Convenience method to grab the first pin in the pins array
      #
      # @return BBB::Pins::AnalogPin
      #
      def pin
        pins.first
      end

      ##
      # Provide a default initializer
      #
      def initialize(options={})
        set_options(options)
      end

      ##
      # Provide a function to handle the options
      #
      # @param options [Hash]
      #
      def set_options(options)
        @positions = [options[:pin],
                      options[:pins],
                      options[:position],
                      options[:path]].flatten.compact
      end
    end
  end
end
