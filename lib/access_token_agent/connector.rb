require 'net/http'

module AccessTokenAgent
  class Connector
    def initialize(options)
      configure options
    end

    def authenticate
      return if @fake_authenticate
      fetch_token unless @known_token && @known_token.valid?
      @known_token.value
    end

    def fetch_token
      @known_token = Token.new(from_auth)
    end

    def from_auth
      response = request
      case response.code
      when '200'
        JSON.parse(response.body)
      when '401'
        raise UnauthorizedError
      else
        raise Error
      end
    end

    def request
      request = Net::HTTP::Post.new(auth_uri)
      request.basic_auth @client_id, @client_secret
      request.form_data = { 'grant_type' => 'client_credentials' }

      Net::HTTP.start(auth_uri.hostname, auth_uri.port) do |http|
        http.request(request)
      end
    end

    def configure(base_uri:,
                  client_id:,
                  client_secret:,
                  fake_authenticate: false)
      @base_uri = base_uri
      @client_id = client_id
      @client_secret = client_secret
      @fake_authenticate = fake_authenticate
    end

    def auth_uri
      @auth_uri ||= URI("#{@base_uri}/oauth/token")
    end

    def env
      ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
    end
  end
end
