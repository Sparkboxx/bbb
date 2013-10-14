module BBB
  class Configuration
    def initialize
    end

    def gpio_path
      "/sys/class/gpio"
    end

    def gpio_direction_read
      "in"
    end

    def gpio_direction_write
      "out"
    end

    def high
      1
    end

    def low
      0
    end
  end
end
