# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hanvon/version'

Gem::Specification.new do |spec|
  spec.name          = "hanvon"
  spec.version       = Hanvon::VERSION
  spec.authors       = ["Heinrich Lee Yu"]
  spec.email         = ["hleeyu@gmail.com"]
  spec.description   = %q{Ruby client for communicating with Hanvon Time & Attendance Devices over the network}
  spec.summary       = %q{Ruby client for Hanvon Time & Attendance Devices}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
