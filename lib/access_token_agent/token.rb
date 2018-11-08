require 'access_token_agent/missing_access_token'
require 'access_token_agent/missing_token_type'
require 'access_token_agent/unsupported_token_type_error'

module AccessTokenAgent
  class Token
    attr_reader :value, :expires_at

    EXPIRY_MARGIN = 60 # seconds

    def initialize(auth_response)
      validate_response(auth_response)

      @value = auth_response['access_token']
      @expires_at = Time.now + auth_response['expires_in']
    end

    def valid?
      @expires_at - EXPIRY_MARGIN > Time.now
    end

    private

    def validate_response(auth_response)
      raise MissingTokenType if auth_response['token_type'].nil?
      unless auth_response['token_type'] == 'Bearer'
        raise UnsupportedTokenTypeError, auth_response['token_type']
      end

      token = auth_response['access_token']
      raise MissingAccessToken if token.nil? || token.empty?
    end
  end
end
