module AccessTokenAgent
  class UnsupportedTokenTypeError < Error
    def initialize(token_type)
      super("Expected token_type to be 'Bearer', but was '#{token_type}'.")
    end
  end
end
