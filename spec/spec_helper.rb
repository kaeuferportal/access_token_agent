ENV['RACK_ENV'] = 'test'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'access_token_agent'
require 'webmock/rspec'
require 'vcr'

RSpec.configure do |config|
  config.mock_with(:rspec) { |mocks| mocks.verify_partial_doubles = true }
  config.before :each do
    AccessTokenAgent.clear
  end

  config.before do
    AccessTokenAgent.configure(
      'base_uri' => 'http://localhost:8012',
      'client_id' => 'test_app',
      'client_secret' =>  '303b8f4ee401c7a0c756bd3acc549a16ba1ee9b194339c2e2' \
                          'a858574dff3a949')
  end
end

VCR.configure do |config|
  config.configure_rspec_metadata!
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
end
