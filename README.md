[![Gem Version](https://badge.fury.io/rb/access_token_agent.svg)](https://badge.fury.io/rb/access_token_agent)
[![Build Status](https://travis-ci.org/kaeuferportal/access_token_agent.svg?branch=master)](https://travis-ci.org/kaeuferportal/access_token_agent)
[![Code Climate](https://codeclimate.com/github/kaeuferportal/access_token_agent/badges/gpa.svg)](https://codeclimate.com/github/kaeuferportal/access_token_agent)
[![Test Coverage](https://codeclimate.com/github/kaeuferportal/access_token_agent/badges/coverage.svg)](https://codeclimate.com/github/kaeuferportal/access_token_agent/coverage)

# AccessTokenAgent

Handles authentication against an OAuth2 provider.

Retrieves an access token from the authentication server using the
OAuth2 [client credentials flow](https://tools.ietf.org/html/rfc6749#section-4.4).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'access_token_agent', '~> 3.1'
```

And then execute:

    $ bundle

## Basic Configuration

Create an instance of AccessTokenAgent::Connector with the desired
configuration and use that instance to authenticate.

Needs the following parameters to instantiate:

* `host` - the server address where the auth provider is running.
* `client_id` - the client_id of the application using this gem.
* `client_secret` - the client_secret of the application using this gem.

Optional parameters:

* `fake_auth` - if true, do not connect to the auth service and return
   a faked access token.
* `access_token_path` - Allows to customize the HTTP path where the
  access token needs to be requested.
  **Default:** `/oauth/token`

### Example

```ruby
AccessTokenAgent::Connector.new(host: 'https://auth.kaeuferportal.de',
                                client_id: 'my_client',
                                client_secret: 'very_secure_and_secret')
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
that AccessToken. An AccessToken is valid for a limited time. The exact value is
determined by the auth response which contains an `expires_at` parameter.
