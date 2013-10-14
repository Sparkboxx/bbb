require 'spec_helper'

describe BBB::Configuration do
  let(:config) { BBB::Configuration.new }
  context "Statics" do
    [:gpio_path, :gpio_direction_read, :gpio_direction_write, :high, :low].each do |method|
      it "#{method.to_s}" do
        config.public_send(method).should_not be_nil
      end
    end
  end
end
