lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date'
require 'intrinio/version'

Gem::Specification.new do |s|
  s.name        = 'intrinio'
  s.version     = Intrinio::VERSION
  s.summary     = 'Intrinio API Library and Command Line'
  s.description = 'Easy to use API for Intrinio data service with a command line interface'
  s.authors     = ['Danny Ben Shitrit']
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.*']
  s.executables = ['intrinio']
  s.homepage    = 'https://github.com/DannyBen/intrinio'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 3.2'

  s.add_dependency 'apicake', '~> 0.2'
  s.add_dependency 'lp', '~> 0.2'
  s.add_dependency 'super_docopt', '~> 0.2'

  s.metadata = {
    'bug_tracker_uri'       => 'https://github.com/dannyben/intrinio/issues',
    'changelog_uri'         => 'https://github.com/dannyben/intrinio/blob/master/CHANGELOG.md',
    'source_code_uri'       => 'https://github.com/dannyben/intrinio',
    'rubygems_mfa_required' => 'true',
  }
end
