module BBB
  module Pins
    ##
    # Module which is included in all pins. The module provides the basic
    # interface for a BBB::Pin and also takes care of selecting the right IO
    # class to work with.
    #
    # It defines a #pinnable? method to test if the module is properly included
    # in a pin.
    #
    module Pinnable
      attr_reader :position, :opts

      ##
      # Initializes a Pin
      #
      # @param position [Symbol] The position of the pin
      # @option opts [Boolean] :mock whether or not to use MockIO
      #
      def initialize(position, opts={})
        @position     = position
        @opts         = opts
      end

      ##
      # Returns an instance of the IO class for the pin and memoizes this.
      #
      # @return [IO]
      #
      def io
        @io ||= mock? ? mock_io : default_io
      end

      ##
      # Returns if this is a mock pin.
      #
      # @return [Boolean]
      #
      def mock?
        @mock ||= @opts.fetch(:mock, false)
      end

      ##
      # Always returns true, method is used to test if module is included.
      #
      # @return [Boolean] true
      #
      def pinnable?
        true
      end

      private

      ##
      # If a class includes the Pinnable module, it should overwrite the
      # default_io method. If this is not done, the module raises an error to
      # point the developer into the right direction.
      #
      # The default_io method should return an instantiated object that makes
      # the interface between the filesystem, drivers etc, and the ruby code.
      # Probably the object will behave like an IO object, relying on the linux
      # kernel and drivers to get things done on the board.
      #
      def default_io
        fail NotImplementedError
      end

      ##
      # The IO instance used for mock pins. By default this is StringIO.new,
      # however, each class should determine if it defines its own MockIO class.
      # An example of which can be found at the PWMPin.
      #
      def mock_io
        StringIO.new
      end
    end
  end
end
