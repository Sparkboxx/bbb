require 'spec_helper'

describe BBB::ADC do

  it "makes some system calls" do
    BBB::ADC.should_receive(:check_if_kernel_module_is_loaded!).and_return(true)
    BBB::ADC.setup
  end
end
