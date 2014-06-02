module BBB
  module Components
    class Button
      attr_reader :status
      attr_accessor :release_callbacks, :press_callbacks

      include Pinnable

      uses BBB::Pins::DigitalInputPin

      def initialize(options={})
        @status = :released
        @release_callbacks = []
        @press_callbacks = []
      end

      def pressed?
        status == :pressed
      end

      def released?
        !pressed
      end

      def press!
        old_state = status
        @status = :pressed
        on_press if old_state != status
      end

      def release!
        old_state = status
        @status = :released
        on_release if old_state != status
      end

      def update(value=pin.high?)
        value == true ? press! : release!
      end

      def on_release(&block)
        @release_callbacks.each{ |c| c.call(status) }
      end

      def on_press(&block)
        if block_given?
          @press_callbacks << block
        else
          @press_callbacks.each{ |c| c.call(status) }
        end
      end

      def high?
        pin.on?
      end
      alias_method :on?, :high?

      def low?
        !high
      end
      alias_method :off?, :low?
    end
  end
end

