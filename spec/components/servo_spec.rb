require 'spec_helper'

describe BBB::Components::Servo do
  let(:servo) { BBB::Components::Servo.new }

  it "initialized detached" do
    servo.attached.should be_false
  end


end
