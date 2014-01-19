module BBB
  module Components
    ##
    # WiiMotionPlus I2C component. Attach to P9 like this:
    #  Nunchuck/ WMP connector:
    # ---------
    # | 1 2 3 |
    # |       |
    # | 6 5 4 |
    # | ----- |
    # |_|   |_|
    #
    # Connections from NunChuck to BeagleBone "P9" connector:
    #
    # pin 1: green: system data - connect to BeagleBone pin 20 (I2C2_SDA)
    # pin 2: (not connected)
    # pin 3: red: DC 3.3V supply - to BeagleBone pin 3 or pin 4 (DC_3.3V)
    # pin 4: yellow - system clock - to BeagleBone pin 19 (I2C2_SCL)
    # pin 5: ("ATT" - not needed)
    # pin 6: white - GND - to BeagleBone pin 1 or pin 2 (GND)
    #
    # Copied from: http://www.alfonsomartone.itb.it/mzscbb.html
    #
    class WiiMotionPlus
      include Pinnable
      uses Pins::I2C

      attr_reader :gyro, :positions

      def initialize(options = {})
        @started = false
        @calibrated = false
        @gyro = Gyro.new
        @positions = [options.fetch(:i2c, nil)].compact
      end

      def start
        begin #check if we can already read, if so, we're already started.
          raw_read
        rescue I2C::AckError
          i2c.write(0x53, 0xfe, 0x04)
        end
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
        bytes = raw_read.bytes.to_a
        @gyro.update(bytes)
        set_extension(bytes)
      end

      def set_extension(bytes)
        @extension_set = bytes[4] & 0b00000001
      end

      def i2c
        pins.first
      end

      def pitch
        gyro.pitch
      end

      def yaw
        gyro.yaw
      end

      def roll
        gyro.roll
      end

      def raw_read
        i2c.read(0x52, 6, 0x00)
      end

      class AxisValue
        attr_reader :value, :slow, :zero_value

        MAX_AMPLITUDE   = 8192 # half of a 14 bit integer
        MAX_MEASUREMENT = 519 # degrees / second
        FACTOR = MAX_AMPLITUDE / MAX_MEASUREMENT


        def initialize
          @value = 0
          @slow = 0
          @zero_value = 8063 # has to be adjusted during calibration
          @calibration_values = []
        end

        def update(value, slow)
          @value = value
          @slow = slow
          @calibration_values << value if @calibrating
        end

        def degrees
          value / FACTOR * slow_correction
        end

        def value
          @value - @zero_value
        end

        def start_calibration!
          @calibrating = true
        end

        def stop_calibration!
          @calibrating = false
          arr = @calibration_values
          @zero_value = arr.inject(0) { |sum, el| sum + el } / arr.size
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
      # (maximum value = 2^14 - 1 = 16383).
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
        HIGH_MASK = 0b11111100

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

        def update(bytes)
          set_yaw(bytes)
          set_pitch(bytes)
          set_roll(bytes)
        end

        def set_yaw(bytes)
          value = (bytes[3] & HIGH_MASK) << 6 | bytes[0]
          slow = bytes[3] & 0b00000010 >> 1
          yaw.update(value, slow)
        end

        def set_pitch(bytes)
          value = (bytes[4] & HIGH_MASK) << 6 | bytes[1]
          slow = bytes[3] & 0b00000001
          pitch.update(value, slow)
        end

        def set_roll(bytes)
          value = (bytes[5] & HIGH_MASK) << 6 | bytes[2]
          slow = bytes[4] & 0b00000010 >> 1
          roll.update(value, slow)
        end

      end
    end
    WMP = WiiMotionPlus
  end
end
