module BBB
  module Pins
    module IO
      class I2C
        include Mapped
        include Cape

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
        end

      end
    end
  end
end
