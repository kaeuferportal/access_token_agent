module AccessTokenAgent
  class Credentials
    attr_reader :client_id, :client_secret

    def initialize(client_id, client_secret)
      @client_id = client_id
      @client_secret = client_secret
    end

    def ==(other)
      client_id == other.client_id && client_secret == other.client_secret
    end

    alias eql? ==

    def hash
      client_id.hash + client_secret.hash
    end
  end
end
