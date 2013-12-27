module BBB
  class Application

    def self.circuit(circuit)
      @_circuit = circuit
      define_convenience_methods
    end

    def self._circuit
      @_circuit
    end

    def self.defince_convenience_methods
      @_circuit.components.keys do |name|
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
