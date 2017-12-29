lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date'
require 'intrinio/version'

Gem::Specification.new do |s|
  s.name        = 'intrinio'
  s.version     = Intrinio::VERSION
  s.date        = Date.today.to_s
  s.summary     = "Intrinio API Library and Command Line"
  s.description = "Easy to use API for Intrinio data service with a command line interface"
  s.authors     = ["Danny Ben Shitrit"]
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.*']
  s.executables = ["intrinio"]
  s.homepage    = 'https://github.com/DannyBen/intrinio'
  s.license     = 'MIT'
  s.required_ruby_version = ">= 2.0.0"

  s.add_runtime_dependency 'docopt', '~> 0.5'
  s.add_runtime_dependency 'awesome_print', '~> 1.7'
  s.add_runtime_dependency 'apicake', '~> 0.1'

  s.add_development_dependency 'runfile', '~> 0.9'
  s.add_development_dependency 'runfile-tasks', '~> 0.4'
  s.add_development_dependency 'rspec', '~> 3.5'
  s.add_development_dependency 'rdoc', '~> 5.1'
  s.add_development_dependency 'byebug', '~> 9.0'
  s.add_development_dependency 'simplecov', '~> 0.14'
  s.add_development_dependency 'yard', '~> 0.9'
end
