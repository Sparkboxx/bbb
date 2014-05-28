require 'spec_helper'

describe BBB do

  it "has a single configuration" do
    a = BBB.configuration
    b = BBB.configuration

    a.test_mode = false
    b.test_mode.should be_false

    a.should eql(b)
    a.test_mode = true
  end

  it "you can temporarily escape test mode" do
    BBB.escape_test do
      BBB.configuration.test_mode.should eql(false)
    end
    BBB.configuration.test_mode.should eql(true)
  end

end
