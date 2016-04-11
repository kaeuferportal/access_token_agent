ENV['RACK_ENV'] = 'test'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'access_token_agent'
require 'webmock/rspec'
require 'vcr'

RSpec.configure do |config|
  config.mock_with(:rspec) { |mocks| mocks.verify_partial_doubles = true }
  config.extend VCR::RSpec::Macros
end


VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
end
