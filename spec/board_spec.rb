require 'spec_helper'

describe BBB::Board do
  it "initializes with a configuration" do
    BBB::Board.should_not_receive(:default_configuration)
    configuration = "SomeConfig"
    board = BBB::Board.new(configuration)
    board.config.should eql(configuration)
  end

  it "initializes with a default configuration" do
    BBB::Board.should_receive(:default_configuration) { 'Default Config' }
    board = BBB::Board.new
  end

end
