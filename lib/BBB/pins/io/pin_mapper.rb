module BBB
  module Pins
    module IO
      ##
      # This class provides a convenient way of mapping a JSON representation of the
      # pins, taken from the bonescript sourcecode, into Ruby objects. After
      # converting the json to ruby objects the "normal" PinMapper will take the
      # object structure and provide the actual mapping from the pin header
      # positions, like p8_3 to the correct GPIO, I2C or WPM endpoints.
      #
      # This class should not be used directly to provide these mappings it's simply
      # a helper class to get from JSON to Ruby.
      #
      class PinMapper
        PIN_MAP_FILE = File.expand_path("../../../../../resources/pin_mappings.json", __FILE__)

        class PinMap < Struct.new(:pins, :uart, :i2c); end

        class Pin    < Struct.new(:name, :gpio, :led, :mux, :key, :mux_reg_offset,
                                  :options, :eeprom, :pwm, :ain, :scale); end
        class UART   < Struct.new(:devicetree, :rx, :tx, :filesystem); end
        class I2C    < Struct.new(:devicetree, :path, :sda, :scl, :filesystem); end

        attr_reader :data

        ##
        # Initialize a JSONPinMapper
        #
        # @param [Hash] hash Hash that was converted from json with the keys
        #   pinIndex, uart and i2c.
        #
        def initialize(hash)
          @data = hash
        end

        ##
        # Factor a new JSONPinMapper based on a json_file that get's parsed to a
        # hash.
        #
        # @param [String] json_filename The file that contains the JSON object with
        #   pin information
        #
        # @return JSONPinMapper instance
        #
        def self.convert(json_filename)
          file = File.open(json_filename, "r")
          hash = JSON.parse(file.read)
          new(hash).convert
        end

        ##
        # Map a pin symbol and a type to a pin_map or raise an error when a pin
        # can't be found.
        #
        # @param [Symbol] pin_symbol
        # @params [Symbol] type Type of the pin.
        #
        def self.map(pin_symbol)
          @map ||= convert(PIN_MAP_FILE)
          begin
            sym = pin_symbol.upcase
            map = @map.pins.fetch(sym, nil)
            map = @map.i2c.fetch(sym) if map.nil?

            return map
          rescue Exception => e
            raise UnknownPinException, "Pin #{pin_symbol} could not be mapped"
          end
        end

        ##
        # Convert from a the data hash to ruby objects
        #
        # @return [Struct] with pins, uart and i2c as keys.
        #   pins has a
        #
        def convert
          pins = convert_pins(data["pinIndex"])
          uart = convert_uart(data["uarts"])
          i2c  = convert_i2c(data["i2c"])

          PinMap.new(pins, uart, i2c)
        end

        ##
        # Converts an array of pins into a hash with the pin key as a key and a Pin
        #   Struct as a value.
        #
        # Here is an example of a piece of the JSON code containing pin info:
        #
        # {
        #     "name": "USR0",
        #     "gpio": 53,
        #     "led": "usr0",
        #     "mux": "gpmc_a5",
        #     "key": "USR0",
        #     "muxRegOffset": "0x054",
        #     "options": [
        #         "gpmc_a5",
        #         "gmii2_txd0",
        #         "rgmii2_td0",
        #         "rmii2_txd0",
        #         "gpmc_a21",
        #         "pr1_mii1_rxd3",
        #         "eqep1b_in",
        #         "gpio1_21"
        #     ]
        # }
        #
        # @param [Array<Hash>] array An array of Pin hashes
        #
        # @return [Hash] a hash with pin keys as keys and pin objects as values.
        #
        def convert_pins(array)
          hash = {}

          array.each do |pin_hash|
            pin = Pin.new
            pin_hash.each_pair do |key, value|
              pin[underscore(key).to_sym] = value
            end
            hash[pin.key.upcase.to_sym] = pin
          end

          return hash
        end

        ##
        # Convert a hash of uarts to a hash with the uart folder (e.g. /dev/tty00)
        #   as the key and an uart object as the value.
        #
        # Here is an example of an individual UART hash:
        #
        #  "/dev/ttyO1": {
        #      "devicetree": "BB-UART1",
        #      "rx": "P9_26",
        #      "tx": "P9_24"
        #  }
        #
        # @param [Hash] data_hash with strings as keys and hashes as values
        #
        # @return [Hash] with strings of uart positions (e.g. /dev/tty00) as keys
        #   and uart objects as values
        #
        def convert_uart(data_hash)
          convert_hash_with_hashes(data_hash, UART)
        end

        ##
        # Convert a hash of I2Cs to a hash with the I2C folder as the key and a i2c
        #   object as the value
        #
        # Here is an example of an individual I2C hash:
        #
        #  "/dev/i2c-1": {
        #      "devicetree": "BB-I2C1",
        #      "path": "/dev/i2c-2",
        #      "sda": "P9_18",
        #      "scl": "P9_17"
        #  }
        #
        # Mind you, the mapping actually turns some of these keys around. The
        # resulting hash takes the "devicetree" as the main key, and adds the
        # key of the JSON object "/dev/i2c-1" as the value of the key
        # :filesystem in the resulting hash. So, to follow the example above,
        # the "mapping" of the example above is:
        #
        #  @example
        #   i2c            = I2C.new
        #   i2c.devicetree = "BB-I2C1"
        #   i2c.filesystem = "/dev/i2c-1"
        #   i2c.path       = "/dev/i2c-2",
        #   i2c.sda        = "P9_18"
        #   i2c.scl        = "P9_17"
        #
        #   map = {:'BB-I2C1' => i2c}
        #
        # ** Beware **
        #
        # The filesystem and path properties are not always the same! Check for
        # example the i2c-1, it is found under the JSON key of /dev/i2c-1 but
        # maps it's path to /dev/i2c-2. It's rather odd...
        #
        # ** End of Beware **
        #
        # @param [Hash] data_hash with strings as keys and hashes as values
        #
        # @return [Hash] with strings of I2C folders as keys and I2C objects as
        #   values
        #
        def convert_i2c(data_hash)
          convert_hash_with_hashes(data_hash, I2C)
        end

        private

        ##
        # @see #convert_uart
        #
        def convert_hash_with_hashes(data_hash, object)
          hash = {}

          data_hash.each_pair do |filesystem, info_hash|
            instance = object.new
            info_hash.each_pair do |key, value|
              instance[key] = value
            end
            instance[:filesystem] = filesystem

            hash[instance.devicetree] = instance
          end

          return hash
        end

        ##
        # Makes an underscored, lowercase form from the expression in the string.
        #
        # Copied from ActiveSupport::Inflections
        # http://api.rubyonrails.org/classes/ActiveSupport/Inflector.html#method-i-underscore
        #
        # Changes '::' to '/' to convert namespaces to paths.
        #
        #   'ActiveModel'.underscore         # => "active_model"
        #   'ActiveModel::Errors'.underscore # => "active_model/errors"
        #
        # As a rule of thumb you can think of +underscore+ as the inverse of
        # +camelize+, though there are cases where that does not hold:
        #
        #   'SSLError'.underscore.camelize # => "SslError"
        def underscore(camel_cased_word)
          word = camel_cased_word.to_s.dup
          word.gsub!('::', '/')
          word.gsub!(/(?:([A-Za-z\d])|^)(#{acronym_regex})(?=\b|[^a-z])/) { "#{$1}#{$1 && '_'}#{$2.downcase}" }
          word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
          word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
          word.tr!("-", "_")
          word.downcase!
          word
        end

        ##
        # Specifies acronyms. This is a shortcut approach to the full acronym
        # functionality of Rails. Which can be found here:
        # https://github.com/rails/rails/blob/4e327225947b933d5434509e02e98226c581adc1/activesupport/lib/active_support/inflector/inflections.rb#L47
        #
        def acronym_regex
          /#{%w(I2C UART GPIO).join("|")}/
        end
      end
    end
  end
end
