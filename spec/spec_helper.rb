$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'codeclimate-test-reporter'
require 'simplecov'
CodeClimate::TestReporter.start
SimpleCov.start
SimpleCov.add_filter 'spec'

require 'access_token_agent'
require 'webmock/rspec'
require 'vcr'

RSpec.configure do |config|
  config.mock_with(:rspec) { |mocks| mocks.verify_partial_doubles = true }
end

VCR.configure do |config|
  config.configure_rspec_metadata!
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.ignore_hosts 'codeclimate.com'
end
