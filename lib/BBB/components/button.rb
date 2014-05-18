module BBB
  module Components
    class Button
      include Pinnable

      uses BBB::Pins::DigitalInputPin

      def high?
        pin.on?
      end
      alias_method :on?, :high?

      def low?
        !high
      end
      alias_method :off?, :low?

      def status
        pin.status
      end
      alias_method :state, :status
    end
  end
end

