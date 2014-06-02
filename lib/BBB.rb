require "json"
require "stringio"

require "BBB/version"
require "BBB/configuration"

require "BBB/pins"
require "BBB/components"
require "BBB/attachable"
require "BBB/circuit"
require "BBB/exceptions"
require "BBB/application"

module BBB

  def self.configuration
    Configuration.instance
  end

  def self.escape_test(&block)
    old_mode = configuration.test_mode
    configuration.test_mode = false
    yield
    configuration.test_mode = old_mode
  end

end
