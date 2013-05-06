# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bowerinstaller/version'

Gem::Specification.new do |spec|
  spec.name          = "bowerinstaller"
  spec.version       = Bowerinstaller::VERSION
  spec.authors       = ["Gary Lin"]
  spec.email         = ["gary@employees.org"]
  spec.description   = "Bower installer for rails"
  spec.summary       = "Bower installer for rails"
  spec.homepage      = "https://github.com/garylin/bowerinstaller-rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
