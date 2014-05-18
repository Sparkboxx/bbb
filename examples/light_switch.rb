require_relative '../lib/BBB'
require 'pry'

class LightSwitch < BBB::Application
  attach BBB::Components::Led, as: :led
  attach BBB::Components::Button, as: :button

  def initialize
    @button_state = false
    led.connect(:P8_10)
    button.connect(:P8_19)

    puts "Press the button to switch the light"
    led.on!
  end

  def run
    if current_button_state != last_button_state
      if led.on?
        led.off!
      else
        led.on!
      end
      store_button_state
    end
  end

  private

  def current_button_state
    @button_state = button.high?
  end

  def last_button_state
    @last_button_state
  end

  def store_button_state
    @last_button_state = @button_state
  end
end

LightSwitch.new.start

