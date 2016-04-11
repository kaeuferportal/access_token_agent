require 'net/http'
require 'yaml'
require 'authentication_connector/token'
require 'authentication_connector/credentials'

module AuthenticationConnector
  @known_tokens = {}

  def self.authenticate(credentials)
    known_token = @known_tokens[credentials]
    if known_token && known_token.valid?
      known_token
    else
      get_token(credentials)
    end
  end

  def self.add(credentials, token)
    @known_tokens[credentials] = token
  end

  def self.get_token(credentials)
    token = Token.new(token_from_auth(credentials))
    add(credentials, token)
    token
  end

  def self.token_from_auth(credentials)

    request = Net::HTTP::Post.new(auth_uri, grant_type: 'client_credentials')
    request.basic_auth credentials.client_id, credentials.client_secret

    # TODO: deal with unsuccessful requests
    result = Net::HTTP.start(auth_uri.hostname, auth_uri.port) do |http|
      http.request(request)
    end
    JSON.parse(result.body)
  end

  def self.auth_uri
    @base_uri ||=
      URI("#{auth_config['protocol']}://#{auth_config['host']}/oauth/token")
  end

  def self.auth_config
    @auth_config ||= YAML.load_file('config/auth.yml')[env]
  end

  def self.env
    ENV['RACK_ENV'] || 'development'
  end
end
