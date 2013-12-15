require 'spec_helper'

describe BBB::ADC::AnalogPin do
  let(:pin) { BBB::ADC::AnalogPin.new(:P9_39, :mock=>true) }
  let(:pin_class) { BBB::ADC::AnalogPin }


  describe "#initialize" do

    describe "mock" do
      it "initializes mock" do
        lambda{ pin }.should_not raise_error
      end

      it "gets a mock handle when initialized with mock" do
        pin.file_handle.class.should eql(StringIO)
      end

      it "saves the mock value in instance variable" do
        pin.mock.should be_true
      end
    end

    describe "the real deal" do
      before :each do
        pin_class.any_instance.should_receive(:ain_path).and_return("some/file")
        File.should_receive(:open).with("some/file","r").and_return(StringIO.new("foo"))
      end

      it "gets file handle" do
        pin_class.new(:P9_39).file_handle.read.should eql("foo")
      end

      it "saves the mock value in an instance variable" do
        pin_class.new(:P9_39).mock.should_not be_true
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
      @p = BBB::ADC::AnalogPin.new(:P9_39, :mock=>true)
    end

    it "gets mock handle with mock argument" do
      handle = @p.get_file_handle(true)
      handle.class.should eql(StringIO)
    end

    it "gets a File handle if explicit no mock" do
      File.should_receive(:open).and_return("file")
      handle = @p.get_file_handle(false)
      handle.should eql("file")
    end

    it "gets a File by default" do
      File.should_receive(:open).and_return("file")
      handle = @p.get_file_handle
      handle.should eql("file")
    end
  end

  describe "#position=" do
    it "sets the instance variable position" do
      pin.position = :P9_40
      pin.instance_variable_get("@position").should eql(:P9_40)
    end

    it "sets the pin_map variable" do
      p = pin
      p.position = :P9_40
      p.instance_variable_get("@pin_map").ain.should eql(1)
    end
  end

  it "#read calls the file handle" do
    p = pin
    p.file_handle.should_receive(:read).and_return("bazinga")
    p.read.should eql("bazinga")
  end

  it "#ain_path calls the map" do
    path = pin.ain_path
    path.should eql("/sys/devices/ocp.3/helper.15/AIN0")
  end

  it "#scale tells the scale" do
    pin.scale.should eql(4096)
  end
end
