module BBB
  module Components
    ##
    # The LED class is the component interface into a digital pin. In a way it's
    # nothing more than a straight forward port of a digital pin. You can use a
    # led component when you want to use digital pins, or simply define your own
    # class and extend it from the LED.
    #
    # The Led class does not perform any sort of caching or smart calls, it
    # forwards everything to the pin. In your own applications you might want to
    # tune this behavior by adding some kind of caching.
    #
    class Led
      include Pinnable

      uses BBB::Pins::DigitalOutputPin

      ##
      # Turns on the LED
      # @return void
      #
      def on!
        pin.on!
      end

      ##
      # Turns off the LED
      # @return void
      #
      def off!
        pin.off!
      end

      ##
      # Checks if the LED is turned on.
      #
      # @return Boolean
      #
      def on?
        pin.on?
      end

      ##
      # Checks if the LED is turned off.
      #
      # @return Boolean
      #
      def off?
        pin.off?
      end


      ##
      # Returns the status of the current led
      #
      def status
        on? ? :on : :off
      end

      ##
      # Toggle the led between on and off
      #
      def toggle!
        if on?
          off!
        elsif off?
          on!
        end
      end

    end
  end
end
