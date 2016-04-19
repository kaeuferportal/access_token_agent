Handles authentication against Käuferportal

Retrieves an access token from https://auth.kaeuferportal.de using the
OAuth2 [client credentials flow](https://tools.ietf.org/html/rfc6749#section-4.4).

## Installation

Add this line to your application's Gemfile:

```ruby
codevault 'access_token_agent', 'kaeuferportal/access_token_agent'
```

And then execute:

    $ bundle

## Configuration

Create an instance of AccessTokenAgent::Connector with the desired
configuration and use that instance to authenticate.

Needs the following parameters:
`base_uri` - the server address where auth is running.
`client_id` - the client_id of the project using this gem.
`client_secret` - the client_secret of the project using this gem.

`client_id` and `client_secret` must correspond to an application in auth.

Optional parameters:
`fake_authentication` - do not connect to auth and return nothing.

### Example

```ruby
@access_token_agent =
  AccessTokenAgent::Connector.new({ base_uri: https://auth.kaeuferportal.de,
                                    client_id: beratung,
                                    client_secret: very_secure_and_secret })
```

## Usage

Setup an AcccessTokenAgent::Connector instance (see Configuration) and call
authenticate on it to receive your access_token.

```
@access_token_agent.authenticate
```

When no valid AccessToken is present a call to authenticate returns one of the
following:
 - a Bearer Token if the credentials are valid (auth response code 200)
 - raises an UnauthorizedError if the credentials are invalid (auth response
   code 401)
 - raises an Error if the auth response code is neither 200 nor 401

As long as a valid AccessToken is present a call to authenticate simply returns
that AccessToken. An AccessToken is valid for some time. The exact value is
determined by the auth response which contains an `expires_at` parameter.
