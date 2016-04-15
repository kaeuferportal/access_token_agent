require 'net/http'
require 'yaml'
require 'access_token_agent/error'
require 'access_token_agent/unauthorized_error'
require 'access_token_agent/token'
require 'access_token_agent/credentials'

module AccessTokenAgent
  @known_token = nil

  def self.authenticate
    fetch_token unless @known_token && @known_token.valid?
    @known_token.value
  end

  def self.add(token)
    @known_token = token
  end

  def self.clear
    @known_token = nil
  end

  def self.fetch_token
    add(Token.new(from_auth))
  end

  def self.from_auth
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

  def self.request
    request = Net::HTTP::Post.new(auth_uri)
    request.basic_auth client_id, client_secret
    request.form_data = { 'grant_type' => 'client_credentials' }

    Net::HTTP.start(auth_uri.hostname, auth_uri.port) do |http|
      http.request(request)
    end
  end

  def self.auth_uri
    @base_uri ||= URI("#{auth_config['base_uri']}/oauth/token")
  end

  def self.configure(options)
    @auth_config = auth_config.merge(options)
  end

  def self.auth_config
    @auth_config || {}
  end

  def self.client_id
    @auth_config['client_id']
  end

  def self.client_secret
    @auth_config['client_secret']
  end

  def self.env
    ENV['RACK_ENV'] || 'development'
  end
end
