require 'spec_helper'

describe BBB::Application do

  it "initializes" do
    lambda { BBB::Application.new }.should_not raise_exception
  end

  class MockCircuit
    def components; {}; end
  end

  class TestBoardApp < BBB::Application
    board "board"
    circuit MockCircuit.new
  end

  it "defaults board to class variable board" do
    TestBoardApp.instance_variable_get('@_board').should eql("board")
  end

  it "sets the board as an instance variable" do
    app = TestBoardApp.new
    app.board.should eql("board")
  end

  it "sets a circuit" do
    app = TestBoardApp.new
    app.circuit.class.should eql(MockCircuit)
  end

  class TestLedCircuit < BBB::Circuit
    def initialize
      attach BBB::Components::Led, pin: :P8_3, as: :led
    end
  end

  class TestConnectionApp < BBB::Application
    board BBB::TestBoard.new
    circuit TestLedCircuit.new
  end

  it "attaches virtual pins to board pins" do
    app = TestConnectionApp.new

    app.circuit.respond_to?(:led).should be_true
    app.circuit.led.should_receive(:on!)
    app.led.should eql(app.circuit.led)

    app.led.on!
  end

end
