# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ramdo/version'

Gem::Specification.new do |spec|
  spec.name          = "ramdo"
  spec.version       = Ramdo::VERSION
  spec.authors       = ["AISLER B.V.", "Patrick Franken"]
  spec.email         = ["p.franken@aisler.net"]
  spec.summary       = "Fast temporary store powered by RAM disks"
  spec.description   = spec.summary
  spec.homepage      = "http://aisler.net"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'filesize'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "geminabox"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "timecop"
end
