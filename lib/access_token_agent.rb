require 'net/http'
require 'yaml'
require 'access_token_agent/error'
require 'access_token_agent/unauthorized_error'
require 'access_token_agent/token'
require 'access_token_agent/credentials'

module AccessTokenAgent
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

  def self.clear
    @known_tokens = {}
  end

  def self.get_token(credentials)
    token = Token.new(from_auth(credentials))
    add(credentials, token)
    token
  end

  def self.from_auth(credentials)
    response = request(credentials)
    case response.code
    when '200'
      JSON.parse(response.body)
    when '401'
      raise UnauthorizedError
    else
      raise Error
    end
  end

  def self.request(credentials)
    request = Net::HTTP::Post.new(auth_uri)
    request.basic_auth credentials.client_id, credentials.client_secret
    request.form_data = { 'grant_type' => 'client_credentials' }

    Net::HTTP.start(auth_uri.hostname, auth_uri.port) do |http|
      http.request(request)
    end
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
