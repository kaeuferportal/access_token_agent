# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'access_token_agent/version'

Gem::Specification.new do |s|
  s.name        = 'access_token_agent'
  s.version     = AccessTokenAgent::VERSION
  s.date        = '2016-04-08'
  s.summary     = 'Handles authentication against an OAuth2 provider'
  s.homepage    = 'https://github.com/kaeuferportal/access_token_agent'
  s.description = 'Retrieves an access token from an OAuth2 provider' \
                  'using the supplied credentials.'
  s.authors     = ['Beko Käuferportal GmbH']
  s.email       = 'oss@kaeuferportal.de'
  s.license     = 'MIT'
  s.files       = `git ls-files -z`.split("\x0")
                                   .reject { |f| f.match(%r{^spec/}) }

  s.add_development_dependency 'bundler', '~> 1.11'
  s.add_development_dependency 'rspec', '~> 3.4'
  s.add_development_dependency 'pry', '~> 0.10'
  s.add_development_dependency 'rubocop', '~> 0.39'
  s.add_development_dependency 'vcr', '~> 3.0'
  s.add_development_dependency 'webmock', '~> 1.24'
  s.add_development_dependency 'simplecov', '~> 0.11'
  s.add_development_dependency 'codeclimate-test-reporter'
end
