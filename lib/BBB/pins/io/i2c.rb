module BBB
  module Pins
    module IO
      class I2C
        include Mapped
        include Cape

        attr_reader :backend

        ##
        # Initializes two I2C pins. The initializer takes the cape argument,
        # where most other IO classes in the library take a position. This is
        # because it seems more natural to indicate BB-I2C1 as opposed to
        # figuring out that I2C1 is mapped to P9_18, and P9_17 (sda, scl) and
        # then give those positions.
        #
        # @param cape [String] The cape name of the I2C chip.
        #
        def initialize(cape)
          @cape = cape
          self.export
        end

        def position
          @cape
        end

        def export
          tree = pin_map.devicetree
          system("echo #{tree} > #{cape_dir}")
          sleep(0.2) # Give the kernel time to load the cape
          @backend = I2C.create(pin_map.path)
        end

        def write(address, *params)
          @backend.write(address, params)
        end

        def read(address, size, *params)
          @backend.read(address, size, params)
        end

      end
    end
  end
end
