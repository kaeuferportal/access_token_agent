**You are viewing an archived version of this project.**

**This project now lives in the aroundhome organization at https://github.com/aroundhome/access_token_agent**

# AccessTokenAgent

Handles authentication against an OAuth2 provider.

Retrieves an access token from the authentication server using the
OAuth2 [client credentials flow](https://tools.ietf.org/html/rfc6749#section-4.4).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'access_token_agent', '~> 4.0'
```

And then execute:

    $ bundle

## Basic configuration

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
@connector = AccessTokenAgent::Connector.new(host: 'https://auth.kaeuferportal.de',
                                             client_id: 'my_client',
                                             client_secret: 'very_secure_and_secret')
```

## Sharing a connector

When connecting to multiple endpoints you will commonly come across the need
to share a single instance of a connector in multiple places, because your
application will use the same configuration everywhere.

You can use the convenience accessor `instance` for that:

```ruby
AccessTokenAgent::Connector.instance = AccessTokenAgent::Connector.new(...)
```

## Usage

Set up an AcccessTokenAgent::Connector instance (see Configuration) and call
`authenticate` on it to receive your access_token.

```ruby
AccessTokenAgent::Connector.instance.authenticate
 => "XYZ"
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

### As HTTP Header

Since the most common use case is to include the access token as [RFC 6750](https://tools.ietf.org/html/rfc6750) bearer token, there is a method that returns the `Authorization: Bearer XYZ` header as hash:

```ruby
AccessTokenAgent::Connector.instance.http_auth_header
 => { "Authorization" => "Bearer XYZ" }
```
