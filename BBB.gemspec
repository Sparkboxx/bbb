# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'BBB/version'

Gem::Specification.new do |spec|
  spec.name          = "BBB"
  spec.version       = BBB::VERSION
  spec.authors       = ["Wilco van Duinkerken"]
  spec.email         = ["wilco@sparkboxx.com"]
  spec.description   = %q{Helper functions to ruby around on the BeagleBone Black}
  spec.summary       = spec.description
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "json"
  spec.add_dependency "i2c"
  spec.add_dependency "sinatra"
  spec.add_dependency "sinatra-websocket"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
