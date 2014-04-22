module BBB
  class Application
    include Attachable

    def start
      activate_components
      loop do
        run
      end
    end

    def activate_components
    end

    def run
      raise NotImplementedError
    end

  end
end
