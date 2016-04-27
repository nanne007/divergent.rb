# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'railway/version'

Gem::Specification.new do |spec|
  spec.name          = "railway"
  spec.version       = Railway::VERSION
  spec.authors       = ["Cao Jiafeng"]
  spec.email         = ["funfriendcjf@gmail.com"]

  spec.summary       = %q{a collection of monad impl in ruby inspired by scala}
  spec.description   = %q{the collection provides railway class for handling errors in ruby}
  spec.homepage      = "http://github.com/lerencao/railway.rb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "pry"
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
