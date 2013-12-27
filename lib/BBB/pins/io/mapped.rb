module BBB
  module Pins
    module IO
      module Mapped
        def pin_map(position)
          return @pin_map unless @pin_map.nil?
          map = PinMapper.map(position, map_key)
          unless map.respond_to?(map_key) && !map.send(map_key).nil?
            raise ArgumentError, "#{position} is not a valid #{map_key.upcase} pin position"
          end

          @pin_map = map
        end

        def pin_map_key
          self.class.to_s.split("::").last.downcase.to_sym
        end
      end
    end
  end
end
