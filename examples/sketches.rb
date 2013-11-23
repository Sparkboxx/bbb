require 'bbb'

module Thunderball
  class Copter << BBB::Application
    ##
    # Use the BBB as the board, allows for possible ports to e.g. the Pi
    #
    board  BBB::Board.new

    ##
    # Load the thunderball layout
    #
    layout Thunderball::Circuit.new

    attr_reader :stabalizer, :mover

    def initialize
      @stabalizer = Stabalizer.new(escs: escs,
                                   gyro: gyro,
                                   accelerometer: acc)

      @mover = Mover.new(escs: escs)
    end

    ##
    # Once start is called the run function will be called in a loop
    #
    def run
      stabalizer
      move(:forward=>20, :right=>10)
    end

    ##
    # Stabalize function is just syntactic sugar to make the run method look nice.
    #
    def stabilize
      stabalizer.update
    end

    ##
    # move function is just syntactic sugar to make the run method look nice.
    #
    def move
      mover.update
    end
  end # Copter

  class Circuit < BBB::Circuit
    def initialize
      attach_escs
      attach_led
    end

    def attach_escs
      attach ESC, :pins=>[:P8_1, :P8_2], :as=>:esc_1, :group=>:escs
      attach ESC, :pins=>[:P9_1, :P9_2], :as=>:esc_2, :group=>:escs
    end

    def attach_leds
      attach Led, :pin=>:P9_12
    end
  end # Circuit

  class Mover
    def initialize(opts={})
      @escs = opts[:escs]
    end

    def move
      # Do some complex logic here with the escs
    end
  end # Mover

  def Stabalizer
    def initialize(opts={})
      @escs = opts[:escs]
      @gyo = opts[:gyro]
      @accelerometer = opts[:accelerometer]
    end

    def stabalize
      # Do someting complex with all the components
      # and update all values
    end
  end #Stabalizer
end
