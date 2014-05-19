require_relative '../lib/BBB'

class LightSwitch < BBB::Application
  attach BBB::Components::Led, as: :led
  attach BBB::Components::Button, as: :button

  def initialize
    led.connect(:P8_10)
    button.connect(:P8_19)

    puts "Press the button to switch the light"
    led.on!
    read_button_state
  end

  def run
    read_button_state

    if current_button_state != last_button_state
      if current_button_state == :high
        if led.on?
          led.off!
        else
          led.on!
        end
      end
      store_button_state
    end
  end

  private

  def read_button_state
    @button_state = button.state
  end

  def current_button_state
    @button_state
  end

  def last_button_state
    @last_button_state
  end

  def store_button_state
    @last_button_state = @button_state
  end
end

LightSwitch.new.start

