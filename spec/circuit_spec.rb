require "spec_helper"

describe BBB::Circuit do
  it "initializes" do
    lambda{ BBB::Circuit.new }.should_not raise_exception
  end

end
