module BBB
  class Board
    attr_reader :config

    def initialize(config=nil)
      @config = config || self.class.default_configuration
    end

    private

    def self.default_configuration
      Configuration.new
    end
  end
end
