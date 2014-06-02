require 'bbb'

##
# This is merely a design file. It doesn't work this way yet and functions
# merely as a way to sketch out how it should work
#
class Quadcopter < BBB::Application

  ##
  # Load 4 ESCs, left-front (lf), right-front (rf), left-back (lb) and
  # right-back(rb).
  #
  # We define them in clockwise order starting front-left, in order to have the
  # array of escs constructed in a way that we can find them later on.
  #
  attach ESC, pins: [:P8_13, :P9_3], as: :esc_lf, group: :escs
  attach ESC, pins: [:P9_14, :P9_2], as: :esc_rf, group: :escs
  attach ESC, pins: [:P9_42, :P9_2], as: :esc_rb, group: :escs
  attach ESC, pins: [:P9_21, :P9_2], as: :esc_lb, group: :escs

  attach Led, pin: :P8_6, as: :power_indicator

  ##
  # Connect the WMP with the nunchuck as extension
  #
  attach WMP, i2c: "BB-I2C1", as: :wmp, extension: "nunchuck"

  attr_reader :stabilizer

  def initialize
    @stabilizer = Stabilizer.new(escs: escs,
                                 gyro: gyro,
                                 accelerometer: acc)
  end

  def gyro
    wmp.gyro
  end

  def acc
    #wmp.nunchuck.accelerometer
  end

  def fly_mode
    stabilizer.mode
  end

  ##
  # Once start is called the run function will be called in a loop
  #
  def run
    stabilizer.update
  end
end # Copter

class Stabilizer
  attr_reader :escs, :gyro, :accelerometer
  attr_reader :mode

  def initialize(opts={})
    @escs          = opts[:escs]
    @gyro           = opts[:gyro]
    @accelerometer = opts[:accelerometer]
    @mode = :hover
  end

  def hover
    @mode = :hover
  end

  def update
    # Do someting complex with all the components
    # and update all values
  end
end #Stabilizer

Quadcopter.new.start if __FILE__ == $0
