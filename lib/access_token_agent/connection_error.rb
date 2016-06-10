module AccessTokenAgent
  class ConnectionError < Error
    def initialize
      super('Could not connect to the auth service.')
    end
  end
end
