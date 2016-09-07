# coding: utf-8

Gem::Specification.new do |s|
  s.name        = 'access_token_agent'
  s.version     = '3.1.0'
  s.date        = '2016-04-08'
  s.summary     = 'Handles authentication against an OAuth2 provider'
  s.description = 'Retrieves an access token from an OAuth2 provider' \
                  'using the supplied credentials.'
  s.authors     = ['Beko Käuferportal GmbH']
  s.email       = 'oss@kaeuferportal.de'
  s.license     = 'MIT'
  s.files       = ['lib/access_token_agent.rb']

  s.add_development_dependency 'bundler', '~> 1.11'
  s.add_development_dependency 'rspec', '~> 3.4'
  s.add_development_dependency 'pry', '~> 0.10'
  s.add_development_dependency 'rubocop', '~> 0.39'
  s.add_development_dependency 'vcr', '~> 3.0'
  s.add_development_dependency 'webmock', '~> 1.24'
  s.add_development_dependency 'simplecov'
end
