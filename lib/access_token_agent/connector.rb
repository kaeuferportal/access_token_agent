require 'net/http'

module AccessTokenAgent
  class Connector
    FAKE_TOKEN = 'FakeAuthToken'.freeze

    class << self
      attr_accessor :instance
    end

    def initialize(host:,
                   client_id:,
                   client_secret:,
                   fake_auth: false,
                   access_token_path: '/oauth/token')
      @host = host
      @client_id = client_id
      @client_secret = client_secret
      @fake_auth = fake_auth
      @access_token_path = access_token_path
    end

    def http_auth_header
      { 'Authorization' => "Bearer #{token}" }
    end

    def token
      return FAKE_TOKEN if @fake_auth
      @known_token = fetch_token unless @known_token && @known_token.valid?

      @known_token.value
    end

    def authenticate
      warn "[DEPRECATION] `#{self.class}.authenticate` is deprecated. " \
           'Use `token` instead.'
      token
    end

    private

    def fetch_token
      Token.new(fetch_token_hash)
    end

    def fetch_token_hash
      response = perform_request
      case response.code
      when '200' then JSON.parse(response.body)
      when '401' then raise UnauthorizedError
      else
        raise Error, "status: #{response.code}, body: #{response.body}"
      end
    rescue Errno::ECONNREFUSED
      raise ConnectionError
    end

    def perform_request
      request = Net::HTTP::Post.new(auth_uri)
      request.basic_auth @client_id, @client_secret
      request.form_data = { 'grant_type' => 'client_credentials' }
      use_tls = auth_uri.scheme == 'https'
      Net::HTTP.start(auth_uri.hostname,
                      auth_uri.port,
                      use_ssl: use_tls) do |http|
        http.request(request)
      end
    end

    def auth_uri
      @auth_uri ||= URI("#{@host}#{@access_token_path}")
    end
  end
end
