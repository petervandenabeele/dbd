# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dbd/version'

Gem::Specification.new do |spec|
  spec.name          = "dbd"
  spec.version       = Dbd::VERSION
  spec.authors       = ["Peter Vandenabeele"]
  spec.email         = ["peter@vandenabeele.com"]
  spec.description   = %q{A data store that (almost) never forgets}
  spec.summary       = %q{A data store that (almost) never forgets}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'rb-fsevent'
  spec.add_development_dependency 'terminal-notifier-guard'
  spec.add_development_dependency 'yard'
  spec.add_runtime_dependency 'neography', '>= 1.2.2'
  spec.add_runtime_dependency 'rdf'
  spec.add_runtime_dependency 'ruby_peter_v', '>= 0.0.11'
end
