module BBB
  module Pins
    module IO
      class AIN
        include Mapped
        include Cape

        attr_reader :io, :position

        def initialize(position)
          @position = position
          self.export
          @io = get_file_handle
        end

        def read
          io.rewind
          io.read.to_i
        end

        def scale
          pin_map.scale
        end

        def export
          `echo cape-bone-iio > #{cape_dir}`
        end

        def get_file_handle
          dir  = Dir.glob("/sys/devices/ocp.*/helper.*/")
          file = File.expand_path("AIN#{pin_map.ain}", dir.first)
          file = File.open(file, "r")
          file.sync = true
          return file
        end

        def self.setup
          check_if_kernel_module_is_loaded!
        end

        def self.check_if_kernel_module_is_loaded!
          ains = `find /sys/ -name '*AIN*'`.split("\n")

          if ains.size > 0
            return true
          else
            raise ModuleNotLoadedException, "Is seems that the ADC module is not
              loaded into the kernel. You might want to try: \n
              sudo modprobe t1_tscadc or add it to the kernel on boot: \n
              echo 't1_tscadc' >> /etc/modules.conf"
          end
        end
      end
    end
  end
end
