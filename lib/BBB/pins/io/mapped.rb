module BBB
  module Pins
    module IO
      module Mapped
        ##
        # Get the pin map as taken from the Bonescript. The Pinmap contains
        # information on things like the pin mode, and the name of the pin on
        # the filesystem. Checkout the documentation on {BBB::Pins::IO::PinMapper PinMapper} for more
        # information and examples of the maps.
        #
        # @return [Hash] pin_map
        #
        def pin_map
          return @pin_map unless @pin_map.nil?

          map = PinMapper.map(self.position)
          map_key = self.pin_map_key

          unless map.respond_to?(map_key) && !map.send(map_key).nil?
            raise ArgumentError, "#{self.position} is not a valid #{map_key.upcase} pin position"
          end

          @pin_map = map
        end

        ##
        # Returns the map key of the current pin. e.g. GPIO or AIN. This key is
        # used to check if the provided position actually can be used using the
        # given IO.
        #
        # @return [Symbol] Map key
        #
        def pin_map_key
          self.class.to_s.split("::").last.downcase.to_sym
        end
      end
    end
  end
end
