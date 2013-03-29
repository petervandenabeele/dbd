# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dbd/version'

Gem::Specification.new do |spec|
  spec.name          = "dbd"
  spec.version       = Dbd::VERSION
  spec.authors       = ["Peter Vandenabeele"]
  spec.email         = ["peter@vandenabeele.com"]
  spec.description   = %q{acquiring, storing and querying facts, data and meaning}
  spec.summary       = %q{acquiring, storing and querying facts, data and meaning}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
