module BBB
  class Application
    include Attachable
    include Components

    ##
    # Start the application by activating the components and
    # load the run loop.
    #
    def start
      loop do
        run
      end
    end

    ##
    # The run funciton gets called as part of the run loop on every iteration.
    # This is where you put your main application code that needs to be
    # evaluaded.
    #
    def run
      raise NotImplementedError
    end

  end
end
