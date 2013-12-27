module BBB
  module Pins
    module Pinnable
      attr_reader :position

      def initialize(position, opts={})
        @position     = position
        @opts         = opts
      end

      def io
        @io ||= mock? ? mock_io : default_io
      end

      def mock?
        @mock ||= @opts.fetch(:mock, false)
      end

      private

      def default_io
        raise NotImplementedError
      end

      def mock_io
        StringIO.new
      end
    end
  end
end
