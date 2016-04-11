module AccessTokenAgent
  class UnauthorizedError < Error
    def initialize
      super('The credentials are invalid.')
    end
  end
end
