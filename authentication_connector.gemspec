Gem::Specification.new do |s|
  s.name        = 'authentication_connector'
  s.version     = '0.0.1'
  s.date        = '2016-04-08'
  s.summary     = 'Handles authentication against Käuferportal.'
  s.description = 'Retrieves an access token from auth.kaeuferportal.de ' \
                  'using the supplied credentials.'
  s.authors     = ['Hagen Mahnke']
  s.email       = 'hagenmahnke@googlemail.com'
  s.files       = ['lib/authentication_connector.rb']

  s.add_development_dependency 'bundler', '~> 1.11'
  s.add_development_dependency 'rspec', '~> 3.4'
  s.add_development_dependency 'pry', '~> 0.10'
  s.add_development_dependency 'rubocop', '~> 0.39'
  s.add_development_dependency 'vcr', '~> 3.0'
  s.add_development_dependency 'webmock', '~> 1.24'
end
