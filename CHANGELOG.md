## master

*no unreleased changes*

## 3.4.0

- Allows value of `token_type` to have any casing

## 3.3.0

- Add `instance` accessor to `AccessTokenAgent::Connector`

## 3.2.1

- Use a string as key in HTTP headers, to be compatible with Ruby < 2.3

## 3.2.0

- Add `http_auth_header` method to the connector, since this is the most
  common use case
- Deprecate the `authenticate` method in favor of the new `token` method
- Allow to configure from which path to get the access token
- Put all errors into the AccessTokenAgent namespace
- Actually return a token when faking auth
- Rename error raised for unsupported token types
- Ensure that access token response carries an access token

## 3.1.1

- Fix broken gem release (missing files)

## 3.1.0

- Raise `AccessTokenAgent::ConnectionError` if the auth service could not be reached.

## 3.0.0

- Rename fake_authenticate parameter to fake_auth
    - This is compatible with the file format that AuthConnector already expects

## 2.0.1

- Remove obsolete class Credentials

## 2.0.0

- Rename base_uri parameter to host
    - This is compatible with the file format that AuthConnector already expects

## 1.0.0

- initial Release
