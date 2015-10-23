# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'toot/auth/version'

Gem::Specification.new do |spec|
  spec.name          = "toot-auth"
  spec.version       = Toot::Auth::VERSION
  spec.authors       = ["Travis Petticrew"]
  spec.email         = ["travis@petticrew.net"]

  spec.summary       = %q{An authentication solution for the toot gem}
  spec.description   = %q{An authentication solution for the toot gem}
  spec.homepage      = "https://github.com/watermarkchurch/toot-auth"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "toot"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
