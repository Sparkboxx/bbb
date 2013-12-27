module BBB
  module Pins
    class PWMPin
      include Pinnable

      %w(duty, polarity, period, run).each do |method|
        define_method("#{method}=") do |value|
          io.write(method.to_sym, value)
        end

        define_method(method) do
          io.read(method.to_sym)
        end
      end

      private

      def default_io
        IO::PWM.new(position)
      end

    end
  end
end
