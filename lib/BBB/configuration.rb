require 'singleton'

module BBB
  class Configuration
    include Singleton

    attr_accessor :test_mode

    def initialize
      @test_mode = false
    end
  end
end

