module BBB
  module ADC
    def self.setup
      check_if_kernel_module_is_loaded!
    end

    def self.check_if_kernel_module_is_loaded!
      ains = `find /sys/ -name '*AIN*'`.split("\n")

      if ains.size > 0
        return true
      else
        raise ModuleNotLoadedException, "Is seems that the ADC module is not
          loaded into the kernel. You might want to try: \n
          sudo modprobe t1_tscadc or add it to the kernel on boot: \n
          echo 't1_tscadc' >> /etc/modules.conf"
      end
    end
  end
end
