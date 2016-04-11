require 'authentication_connector/invalid_token_type_error'

module AuthenticationConnector
  class Token
    attr_reader :value, :expires_at

    EXPIRY_MARGIN = 60  # seconds

    def initialize(auth_response)
      unless auth_response['token_type'] == 'bearer'
        raise InvalidTokenTypeError, auth_response['token_type']
      end
      @value = auth_response['access_token']
      @expires_at = Time.now + auth_response['expires_in']
    end

    def valid?
      @expires_at - EXPIRY_MARGIN > Time.now
    end
  end
end
