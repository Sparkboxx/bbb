module BBB
  module IO
    module Pinnable
      attr_reader :position

      def position=(position)
        @position = position
      end
    end
  end
end

