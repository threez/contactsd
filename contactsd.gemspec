# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'contactsd/version'

Gem::Specification.new do |spec|
  spec.name          = "contactsd"
  spec.version       = Contactsd::VERSION
  spec.authors       = ["Vincent Landgraf"]
  spec.email         = ["vincent@landgrafx.de"]
  spec.license       = "MIT"
  spec.summary       = %q{macOS contacts RESTful API daemon}
  spec.description   = %q{
    Gives other programs and scripts access to the mac contacts
    (aka Address Book) using a RESTful API
  }
  spec.homepage      = "https://github.com/threez/contactsd"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]


  spec.add_dependency "rb-scpt", "~> 1.0.1"
  spec.add_dependency "sinatra", "~> 1.4.7"
  spec.add_dependency "vcardigan", "~> 0.0.9"
  spec.add_dependency "thor", "~> 0.19.4"
  spec.add_dependency "puma", "~> 3.6.2"
  spec.add_dependency "pidfile", "~> 0.3.0"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
end
