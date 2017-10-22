# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'opening_act/version'

Gem::Specification.new do |spec|
  spec.name          = 'opening_act'
  spec.version       = OpeningAct::VERSION
  spec.authors       = ['Sun-Li Beatteay']
  spec.email         = ['sjbeatteay@gmail.com']

  spec.summary       = 'A tool that creates the Sinatra development environment for you.'
  spec.description   = "A gem that auto generates all the files, folders and tests you'll need to start your Sinatra application."
  spec.homepage      = 'https://github.com/sunny-b/opening_act'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'minitest-reporters'
  spec.add_development_dependency 'rspec'
end
