require 'net/http'

module AccessTokenAgent
  class Connector
    def initialize(options)
      configure options
    end

    def authenticate
      return if fake_authenticate
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
      request.basic_auth client_id, client_secret
      request.form_data = { 'grant_type' => 'client_credentials' }

      Net::HTTP.start(auth_uri.hostname, auth_uri.port) do |http|
        http.request(request)
      end
    end

    def configure(options)
      @auth_config = options.select do |key, _value|
        ['base_uri', 'client_id', 'client_secret', 'fake_authenticate'].include? key
      end
    end

    def auth_uri
      @base_uri ||= URI("#{@auth_config['base_uri']}/oauth/token")
    end

    def client_id
      @auth_config['client_id']
    end

    def client_secret
      @auth_config['client_secret']
    end

    def fake_authenticate
      @auth_config['fake_authenticate']
    end

    def env
      ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
    end
  end
end
