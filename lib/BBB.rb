require "json"
require "stringio"

require "BBB/version"

require "BBB/circuit"
require "BBB/exceptions"

require "BBB/pins/io/pin_mapper"
require "BBB/pins/io/mapped"
require "BBB/pins/io/cape"
require "BBB/pins/io/ain"
require "BBB/pins/io/gpio"
require "BBB/pins/io/pwm"
require "BBB/pins/io/i2c"

require "BBB/pins/pinnable"
require "BBB/pins/digital_pin"
require "BBB/pins/analog_pin"
require "BBB/pins/pwm_pin"
require "BBB/pins/i2c"
require "BBB/pins/esc"

require "BBB/components/pinnable"
require "BBB/components/analog_component"
require "BBB/components/led"
require "BBB/components/servo"
require "BBB/components/wii_motion_plus"

require "BBB/application"

module BBB
end
