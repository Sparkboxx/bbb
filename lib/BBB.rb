require "BBB/version"

require "json"

require "BBB/board/base"
require "BBB/board/test_board"
require "BBB/board/json_pin_mapper"
require "BBB/board/pin_mapper"

require "BBB/circuit"
require "BBB/exceptions"

require "BBB/gpio/base"
require "BBB/gpio/digital_pin"
require "BBB/gpio/pin_converter"

require "BBB/adc/setup"
require "BBB/adc/analog_pin"

require "BBB/pwm/pwm_pin"

require "BBB/io/pinnable"
require "BBB/io/digital_pin"
require "BBB/io/analog_pin"
require "BBB/io/pwm_pin"
require "BBB/io/mock_pin"

require "BBB/components/pinnable"
require "BBB/components/led"
require "BBB/components/analog_component"

require "BBB/application"

module BBB
end
