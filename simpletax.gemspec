# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simpletax/version'

Gem::Specification.new do |spec|
  spec.name          = "simpletax"
  spec.version       = Simpletax::VERSION
  spec.authors       = ["Ismael Abreu"]
  spec.email         = ["ismaelga@gmail.com"]
  spec.summary       = %q{Ruby API client to gosimpletax.com}
  spec.description   = %q{Ruby API client to gosimpletax.com}
  spec.homepage      = "http://github.com/ismaelga/simpletax"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "multi_json"
  spec.add_dependency "oauth2"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
