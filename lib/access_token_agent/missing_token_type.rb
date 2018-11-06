module AccessTokenAgent
  class MissingTokenType < Error
    def initialize
      super('The access token response did not contain a token type.')
    end
  end
end
