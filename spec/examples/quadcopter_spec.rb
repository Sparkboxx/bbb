require 'spec_helper'
require_relative '../../examples/quadcopter'

describe Quadcopter do
  let(:copter) { described_class.new }

  it "counts 4 escs" do
    escs = copter.escs
    escs.count.should eql(4)
    classes = escs.map(&:class).uniq
    classes.count.should eql(1)
    classes.first.should eql(BBB::Components::ESC)
  end

  it "responds to 1 wmp on the WiiMotionPlus" do
    copter.wmp.class.should eql(BBB::Components::WMP)
  end

  it "responds to the names of the escs" do
    copter = described_class.new
    copter.esc_lf.class.should eql(BBB::Components::ESC)
    copter.esc_rf.class.should eql(BBB::Components::ESC)
    copter.esc_lb.class.should eql(BBB::Components::ESC)
    copter.esc_rb.class.should eql(BBB::Components::ESC)
  end

  it "has a stabilizer" do
    copter.respond_to?(:stabilizer).should be_true
  end

  it "passes the secs to the stabilizer" do
    copter.stabilizer.escs.should eql(copter.escs)
  end

  it "provides quick access to gyro on wmp" do
    copter.gyro.should eql(copter.wmp.gyro)
  end

  it "should know about fly mode" do
    copter.respond_to?(:fly_mode).should be_true
  end

  it "defaults to a hover fly mode" do
    copter.fly_mode.should eql(:hover)
  end

  it "consults the stabilizer for fly mode info" do
    copter.stabilizer.should_receive(:mode).and_return("wicked acrobatics")
    copter.fly_mode.should eql("wicked acrobatics")
  end

  context "complex attach commands" do

    it "remembers both pins given" do
      copter.esc_lf.positions.should eql([:P8_13, :P9_3])
    end

    it "remembers a single pin given" do
      copter.power_indicator.positions.should eql([:P8_6])
    end
  end

end

describe Stabilizer do
  let(:stabilizer) { described_class.new }

  it "reponds to hover" do
    stabilizer.respond_to?(:hover).should be_true
  end

  it "reponds to update" do
    stabilizer.respond_to?(:update).should be_true
  end

  [:escs, :gyro, :accelerometer].each do |key|
    it "sets #{key} on initialization" do
      number = rand(100)
      instance = described_class.new(:"#{key}"=>number)
      instance.send(key).should eql(number)
    end
  end

  it "sets default mode to hover" do
    stabilizer.mode.should eql(:hover)
  end

end


