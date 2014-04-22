module BBB
  module Components
    class Nunchuck
      include Pinnable
      uses Pins::I2C

      attr_reader :accelerometer, :controls

      def initialize(options={})
        @started       = false
        @positions     = options[:i2c] || []
        @accelerometer = Accelerometer.new
        @controls      = Controls.new
        @decoder       = Decoder.new
      end

      def start
        begin
          raw_read
        rescue I2C::AckError
          i2c.write(0x52, 0x40, 0x00)
        end
        @started = true
      end

      def started?
        @started
      end

      def update
        bytes = raw_read.bytes.to_a
        @accelerometer.update(bytes)
        @controls.update(bytes)
      end

      def raw_read
        decoder.decode i2c.read(0x52, 6, 0x00)
      end

      def z; controls.z; end
      def c; controls.c; end
      def x; controls.x; end
      def y; controls.z; end
      def accel; accelerometer; end

      class Decoder
        def decode(bytes)
          bytes.map{|b| b^0x17 + 0x17}
        end
      end

      class Accelerometer
        def initialize
          @x = AccelAccess.new
          @y = AccelAccess.new
          @z = AccelAccess.new
        end

        def update(bytes)
          set_x(bytes)
          set_y(bytes)
          set_z(bytes)
        end

        def set_x(bytes)
          value = (bytes[2] << 2) | ((bytes[5] & 0b00001100) >> 2)
          x.update(value)
        end

        def set_y(bytes)
          value = (bytes[3] << 2) | ((bytes[5] & 0b00110000) >> 4)
          y.update(value)
        end

        def set_z(bytes)
          value = (bytes[4] << 2) | ((bytes[5] & 0b11000000) >> 6)
          z.update(value)
        end

        class AccelAccess
          attr_reader :value

          def update(value)
            @value = value
          end
        end
      end

      class Controls
        def initialize
          initialize_buttons
          initialize_axis
        end

        def initialize_buttons
          @buttons = Hash.new
          @buttons[:z] = Button.new
          @buttons[:c] = Button.new
        end

        def c
          @buttons[:c]
        end

        def z
          @buttons[:z]
        end

        def initialize_axis
          @axis = Hash.new
          @axis[:x] = ControlAxis.new
          @axis[:y] = ControlAxis.new
        end

        def update(bytes)
          update_buttons(bytes)
          update_axis(bytes)
        end

        def update_buttons(bytes)
          x = bytes[5] & 0b00000010 >> 1
          y = bytes[5] & 0b00000001

          @buttons[:x].update(x)
          @buttons[:y].update(y)
        end

        def update_axis(bytes)
          @axis[:x].update(bytes[0])
          @axis[:y].update(bytes[1])
        end

        class Button
          attr_reader :status
          attr_accessor :release_callbacks, :press_callbacks

          def initialize
            @status = :released
            @release_callbacks = []
            @press_callbacks = []
          end

          def pressed?
            status == :pressed
          end

          def press!
            @status = :pressed
            on_press if old_state != status
          end

          def release!
            old_state = status
            @status = :released
            on_release if old_state != status
          end

          def released?
            !pressed
          end

          def update(value)
            value == true ? release! : press!
          end

          def on_release
            @release_callbacks.each{ |c| c.call(status) }
          end

          def on_press
            @press_callbacks.each{ |c| c.call(status) }
          end

        end

        class ControlAxis
          attr_accessor :value
          attr_accessor :change_callbacks

          def initialize
            @change_callbacks = []
          end

          def update(value)
            old_value = self.value
            @value = value
            on_change if old_value != value
          end

          def on_change
            @change_callbacks.each{|c| c.call(value) }
          end
        end
      end
    end
  end
end
