require 'spec_helper'

describe BBB::Configuration do

  it "test mode on when testing" do
    BBB.configuration.test_mode.should be_true
  end

  it "can be set to a different value" do
    BBB.configuration.test_mode = false
    BBB.configuration.test_mode.should be_false
    BBB.configuration.test_mode = true
    BBB.configuration.test_mode.should be_true
  end

end
