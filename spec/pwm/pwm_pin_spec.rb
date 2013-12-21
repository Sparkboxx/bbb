require 'spec_helper'

describe BBB::PWM::PWMPin do
  let(:pin) { BBB::PWM::PWMPin.new(:P8_13, :mock=>true) }
  let(:pin_class) { BBB::PWM::PWMPin }

  describe "#initialize" do

    describe "mock" do
      it "initializes mock" do
        lambda{ pin }.should_not raise_error
      end

      it "gets mock handles when initialized with mock" do
        pin.file_handles.values.map(&:class)
          .uniq.first.should eql(StringIO)
      end

      it "saves the mock value in instance variable" do
        pin.mock.should be_true
      end
    end

    describe "the real deal" do
      before :each do
        pin_class.any_instance.should_receive(:pwm_path)
          .exactly(4).times.and_return("some/file")
        File.should_receive(:open)
          .exactly(4).times
          .and_return("foo")
        pin_class.any_instance.should_receive(:export).and_return(1)
      end

      it "gets file handles" do
        p = pin_class.new(:P8_13)
        p.file_handles.values.count.should eql(4)
        p.file_handles.values.uniq.first.should eql("foo")
      end

      it "saves the mock value in an instance variable" do
        pin_class.new(:P8_13).mock.should_not be_true
      end
    end

    it "sets the pin position" do
      pin_class.any_instance.should_receive(:'position=')
      pin
    end

    it "fails when initializing a non AIN pin position" do
      lambda{pin_class.new(:P8_2, :mock=>true)}.should raise_error(ArgumentError)
    end

  end

  describe "#get_file_handle" do
    before :all do
      @p = BBB::PWM::PWMPin.new(:P8_13, :mock=>true)
    end

    it "gets mock handles with mock argument" do
      handles = @p.get_file_handles(true)
      handles.values.map(&:class).uniq.first.should eql(StringIO)
    end

    it "gets a File handle if explicit no mock" do
      File.should_receive(:open).exactly(4).times.and_return("file")
      Dir.should_receive(:glob).exactly(1).times.and_return("tmp/")
      pin_class.any_instance.should_receive(:export).and_return(1)
      handles = @p.get_file_handles(false)
      handles.values.uniq.count.should eql(1)
      handles.values.uniq.first.should eql("file")
    end

  end

  describe "#position=" do
    it "sets the instance variable position" do
      pin.position = :P8_13
      pin.instance_variable_get("@position").should eql(:P8_13)
    end

    it "sets the pin_map variable" do
      p = pin
      p.position = :P8_13
      p.instance_variable_get("@pin_map").key.should eql("P8_13")
    end
  end

  %w(duty period polarity run).each do |method|
    it "##{method} calls write" do
      p = pin
      value = 1234
      p.should_receive(:write).with(method.to_sym, value).and_return(1234)
      p.send("#{method}=".to_sym, value).should eql(value)
    end
  end

  it "#pwm_path calls the map" do
    pin.pin_map.should_receive(:key)
    path = pin.pwm_path
  end

end
