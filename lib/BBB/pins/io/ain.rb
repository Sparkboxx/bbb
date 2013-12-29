module BBB
  module Pins
    module IO
      class AIN
        include Mapped

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
          cape_dir = "/sys/devices/bone_capemgr.*/slots"
          dir = Dir.glob(cape_dir)
          if dir.length == 0
            raise BoardError, "unable to access the capemgr directory: #{cape_dir}"
          end
          `echo cape-bone-iio > #{dir.first}`
        end

        def get_file_handle
          dir  = Dir.glob("/sys/devices/ocp.*/helper.*/")
          file = File.expand_path("AIN#{pin_map.ain}", dir.first)
          return File.open(file, "r")
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
