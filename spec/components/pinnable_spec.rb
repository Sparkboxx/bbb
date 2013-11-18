require 'spec_helper'

describe BBB::Components::Pinnable do
  class DummyComponent
    include BBB::Components::Pinnable

    def initialize
      pin = Struct.new(:position)
      @pins = [pin.new(0), pin.new(1)]
    end
  end

  it "knows how to register pins" do
    comp = DummyComponent.new
    comp.register_pin_positions(:P8_3, :P8_4)
    comp.pins[0].position.should eql(:P8_3)
    comp.pins[1].position.should eql(:P8_4)
  end
end
