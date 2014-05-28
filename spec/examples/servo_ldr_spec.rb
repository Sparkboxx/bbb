require 'spec_helper'
require_relative "../../examples/servo_ldr"

describe LDRServo do

  context "Direction" do
    it "keeps direction when equal measuement" do
      finder = described_class.new
      finder.ldr.should_receive(:read).twice.and_return(0)
      old_direction = finder.direction
      finder.run
      finder.direction.should eql(old_direction)
    end

    it "reverses direction when moving away from light" do
      finder = described_class.new
      finder.previous_value = 50
      finder.ldr.should_receive(:read).and_return(30)
      finder.servo.should_receive(:angle)
      old_direction = finder.direction

      finder.run
      finder.direction.should_not eql(old_direction)
    end

    it "continues direction when moving towards from light" do
      finder = described_class.new
      finder.previous_value = 30
      finder.ldr.should_receive(:read).and_return(50)
      finder.servo.should_receive(:angle)
      old_direction = finder.direction

      finder.run
      finder.direction.should eql(old_direction)
    end

  end

  context "angle adjustment" do
    it "not needed when receiving same value" do
      finder = described_class.new
      finder.ldr.should_receive(:read).twice.and_return(0)
      finder.servo.should_not_receive(:angle)
      finder.run
    end

    it "needed when moving away from light" do
      finder = described_class.new
      finder.previous_value = 50
      finder.ldr.should_receive(:read).and_return(30)
      finder.servo.should_receive(:angle)
      finder.run
    end

    it "needed when moving towards light" do
      finder = described_class.new
      finder.previous_value = 30
      finder.ldr.should_receive(:read).and_return(50)
      finder.servo.should_receive(:angle)
      finder.run
    end
  end

  context "setting the angle" do
    it "to maximum when given a value above maximm" do
      finder = described_class.new
      finder.angle=200
      finder.angle.should eql(finder.max_servo_angle)
    end

    it "to minimum when given a value below minumum" do
      finder = described_class.new
      finder.angle=-10
      finder.angle.should eql(finder.min_servo_angle)
    end

    it "to maximum when given maximum value" do
      finder = described_class.new
      finder.angle=finder.max_servo_angle
      finder.angle.should eql(finder.max_servo_angle)
    end

    it "to minimum when given a value below minumum" do
      finder = described_class.new
      finder.angle=finder.min_servo_angle
      finder.angle.should eql(finder.min_servo_angle)
    end

    it "to value when given a value within range" do
      finder = described_class.new
      finder.angle=100
      finder.angle.should eql(100)
    end
  end
end
