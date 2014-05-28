require_relative '../lib/BBB'

class LightSwitch < BBB::Application
  attach BBB::Components::Led,    as: :led
  attach BBB::Components::Button, as: :button

  def initialize
    led.connect(:P8_10)
    button.connect(:P8_19)

    led.on!

    button.on_press do
      led.toggle!
    end
  end

  def start
    puts "Press the button to switch the light"
    super
  end

  def run
    button.update
  end
end

LightSwitch.new.start if __FILE__==$0
