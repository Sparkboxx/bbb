module BBB
  module Pins
    module IO
      module Cape
        def cape_dir
          return @cape_dir if @cape_dir

          cape_dir = "/sys/devices/bone_capemgr.*/slots"
          dir = Dir.glob(cape_dir)
          if dir.length == 0
            raise BoardError, "unable to access the capemgr directory: #{cape_dir}"
          end
          @cape_dir = dir.first
        end

      end
    end
  end
end
