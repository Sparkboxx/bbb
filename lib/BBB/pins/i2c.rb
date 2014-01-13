module BBB
  module Pins
    class I2C
      include Pinnable

      def read(address, size, *params)
        @io.read(address, size, *params)
      end

      def write(address, *params)
        @io.read(address, *params)
      end

      private

      def default_io
        IO::I2C.new(postition)
      end

    end
  end
end
