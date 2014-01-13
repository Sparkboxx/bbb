module BBB
  module Components
    class WiiMotionPlus
      include Pinnable
      uses Pins::I2C

      def initialize
        @started = false
        @calibrated = false
        @gyro = Gyro.new
      end

      def start
        i2c.write(0x53, 0xfe, 0x04)
        @started = true
      end

      def started?
        @started
      end

      def calibrated?
        @calibrated
      end

      def calibrate(number=20)
        start unless started?
        @gyro.start_calibration!
        number.times do
          update
        end
        @gyro.stop_calibration!
        @calibrated = true
      end

      def update
        reading = i2c.read(0x52, 0x00)
        @gyro.update(reading)
        set_extension(reading)
      end

      def set_extension(reading)
        @extension_set = reading.bytes[4] & 0b00000001
      end

      def i2c
        pins.first
      end

      class AxisValue
        attr_reader :value, :slow, :zero_value

        MAX_AMPLITUDE   = 8192 # half of a 14 bit integer
        MAX_MEASUREMENT = 519 # degrees / second
        FACTOR = MAX_AMPLITURE / MAX_MEASUREMENT

        HIGH_MASK = 0b11111100

        def initialize
          @value = 0
          @slow = 0
          @calibration_zero = 8063 # has to be adjusted during calibration
          @calibration_values = []
        end

        def update(value, slow)
          @value = value
          @slow = slow
          @calibration_values << value if @calibrating
        end

        def degrees
          (value - calibration_zero) / FACTOR * slow_correction
        end

        def start_calibration!
          @calibrating = true
        end

        def stop_calibration!
          @calibrating = false
          arr = @calibration_values
          @calibration_zero = arr.inject(0) { |sum, el| sum + el } / arr.size
          @calibration_values = []
        end

        # At high speed (slow bit = 0) raw values read are small with the same
        # deg/s to reach higher values on top, so you must multiply it by
        # 2000/440 (they are the max reference in the two modes in deg/s [1]).
        #
        # Example: reading 8083 raw value and assuming 8063 as zero, 20 unit in
        # slow/normal mode are 1,45 deg/s and in fast mode are
        # 1.45*2000/440=6.59 deg/s.
        #
        def slow_correction
          slow ? 2000/440 : 1
        end
      end

      #
      # DATA FORMAT WII MOTION PLUS (GYRO)
      #
      # as taken from:
      # http://wiibrew.org/wiki/Wiimote/Extension_Controllers/Wii_Motion_Plus
      #
      # The YAW, PITCH and ROLL values are 14 bit integers
      # (maximum value = 2^14 - 1 = 8191).
      #
      # The first 8 bits are available in the first Byte. The last 6 bits are
      # available in bits 8 to 13 in byte 3.
      #
      # Bit positions count from right to left. So bit position 0 is the most
      # 'right' bit, and bit 13 bit is the most 'left' bit.
      #
      # this is also why you see the <13:8> position definition in bytes 3,4 and 5.
      #
      # |------|--------------------------------------------------------------|
      # |      |                              Bit                             |
      # |------|--------------------------------------------------------------|
      # | Byte |  7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
      # |------|--------------------------------------------------------------|
      # |  0   |                  Yaw Down Speed<7:0>                         |
      # |------|--------------------------------------------------------------|
      # |  1   |                  Roll Left Speed<7:0>                        |
      # |------|--------------------------------------------------------------|
      # |  2   |                  Pitch Left Speed<7:0>                       |
      # |------|--------------------------------------------------------------|
      # |  3   |              Yaw Down Speed<13:8>            | yaw   | pitch |
      # |      |                                              | slow  | slow  |
      # |      |                                              | mode  | mode  |
      # |------|--------------------------------------------------------------|
      # |  4   |              Roll left speed<13:8>           | roll  | ext.  |
      # |      |                                              | slow  | conn- |
      # |      |                                              | mode  | ected |
      # |------|--------------------------------------------------------------|
      # |  5   |              Pitch left speed<13:8>          |   1   |   0   |
      # |------|--------------------------------------------------------------|
      #
      #
      class Gyro
        attr_reader :yaw, :pitch, :roll

        def initialize
          @yaw   = AxisValue.new
          @pitch = AxisValue.new
          @roll  = AxisValue.new
          @calibrating = false
        end

        def calibrating?
          @calibrating
        end

        def start_calibration!
          @calibrating = true
          [yaw,pitch,roll].each(&:start_calibration!)
        end

        def stop_calibration!
          [yaw,pitch,roll].each(&:stop_calibration!)
          @calibrating = false
        end

        def update(reading)
          set_yaw(reading)
          set_pitch(reading)
          set_roll(reading)
        end

        def set_yaw(reading)
          value = (reading.bytes[3] & HIGH_MASK) << 8 | reading.bytes[0]
          slow = reading.bytes[3] & 0b00000010
          yaw.update(value, slow)
        end

        def set_pitch(reading)
          value = (reading.bytes[4] & HIGH_MASK) << 8 | reading.bytes[1]
          slow = reading.bytes[3] & 0b00000001
          pitch.update(value, slow)
        end

        def set_roll(reading)
          value = (reading.bytes[5] & HIGH_MASK) << 8 | reading.bytes[2]
          slow = reading.bytes[4] & 0b00000010
          roll.update(value, slow)
        end

      end
    end
  end
end
