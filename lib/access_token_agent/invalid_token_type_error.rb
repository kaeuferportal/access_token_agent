module AccessTokenAgent
  class InvalidTokenTypeError < Error
    def initialize(token_type)
      super("Expected token_type to be 'bearer', but was '#{token_type}'.")
    end
  end
end
