module BBB
  class Application

    def self.circuit(circuit)
      @_circuit = circuit
      define_convenience_methods(circuit)
    end

    def self._circuit
      @_circuit
    end

    def self.define_convenience_methods(c)
      c.components.keys.each do |name|
        define_method(name) do
          circuit.send(name)
        end
      end
    end

    def circuit
      self.class._circuit
    end

    def start
      loop do
        run
      end
    end

    def run
      raise NotImplementedError
    end

  end
end
