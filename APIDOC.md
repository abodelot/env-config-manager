# APIDOC

## Authentication

### Sign-in

```
[POST] /users/sign_in.json
{
  user: {
    email: 'user@domain.tld',
    password: 'foobaz123'
  }
}
```

You must include the user email and the returned `authentication_token` in your
request header to perform API calls as an authenticated user. A user cannot open
simultaneous sessions, opening a new session will invalidate previously created
authentication tokens. Example:

```ruby
request = Net::HTTP::Get.new(url)
request.add_field('X-User-Email', email)
request.add_field('X-User-Token', authentication_token)
```

## Environments

Note: `Environment` objects are identified by their `name` attribute, not by
their `id`.

### Get list of environments

`[GET] /api/environments.json`

### Get config for a given environment

`[GET] /api/environments/:name.json`

### Update variables for a given environment

```
[PUT] /api/environments/:name.json
{
  config: {
    key_1: "value_1",
    key_2: "value_2"
  }
}
```

### Delete a given environment and its variables

[DELETE] /api/environments/:name.json

## Users

`[GET] /api/users/.json`

 - `string` *email*: Filter response on users with given email

`[GET] /api/users/:id.json`
