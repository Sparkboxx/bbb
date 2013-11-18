module BBB
  class Application

    def self.board(board)
      @_board = board
      connect unless @_circuit.nil?
    end

    def self.circuit(circuit)
      @_circuit = circuit
      connect unless @_board.nil?
    end

    def self._board
      @_board
    end

    def self._circuit
      @_circuit
    end

    def self.connect
      @_circuit.components.values.each do |component|
        component.pins.each do |pin|
          @_board.connect_io_pin(pin)
        end
      end
    end

    def board
      @board ||= self.class._board
    end

    def circuit
      @circuit ||= self.class._circuit
    end


  end
end
