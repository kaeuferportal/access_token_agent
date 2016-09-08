module AccessTokenAgent
  class MissingAccessToken < Error
    def initialize
      super('The access token response did not contain an access token.')
    end
  end
end
