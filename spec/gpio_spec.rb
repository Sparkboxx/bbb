require 'spec_helper'

describe BBB::GPIO::Base do
  let(:gpio_33) { BBB::GPIO::Base.new(33) }
  let(:gpio_base) { BBB::GPIO::Base.new }

  context "Statics values" do
    [:gpio_path, :gpio_direction_input, :gpio_direction_output,
     :export_path, :unexport_path, :gpio_pin_dir].each do |method|

      it "#{method.to_s}" do
        gpio_base.public_send(method).should_not be_nil
      end

    end
  end

  it "should have a file_class" do
    gpio_base.respond_to?(:file_class).should be_true
  end

  context "Filesystem functions" do
    before(:each) do
      gpio_33.should_receive(:file_class).and_return(StringIO)
    end

    it "should export" do
      gpio_33.export.should eql(2)
    end

    it "should unexport" do
      gpio_33.unexport.should eql(2)
    end

  end

end
