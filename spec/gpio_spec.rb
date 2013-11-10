require 'spec_helper'

describe BBB::GPIO::Base do
  let(:gpio_33) { BBB::GPIO::Base.new(33, mock: true) }
  let(:gpio_base) { BBB::GPIO::Base.new(nil, mock: true) }

  context "Statics values" do
    [:gpio_path, :gpio_direction_input, :gpio_direction_output,
     :export_path, :unexport_path, :gpio_pin_dir].each do |method|

      it "#{method.to_s}" do
        gpio_base.public_send(method).should_not be_nil
      end

    end
  end

  it "should be able to mock using StringIO" do
    BBB::GPIO::Base.new(nil, mock: true).file_class.should eql(StringIO)
  end

  it "should default to File class" do
    BBB::GPIO::Base.new(nil).file_class.should eql(File)
  end

  it "should be able to explicitly set File class" do
    BBB::GPIO::Base.new(nil, mock: false).file_class.should eql(File)
  end

  it "should have a file_class" do
    gpio_base.respond_to?(:file_class).should be_true
  end

  context "Filesystem functions" do
    it "should export" do
      gpio_33.export.should eql(2)
    end

    it "should unexport" do
      gpio_33.unexport.should eql(2)
    end
  end

end
