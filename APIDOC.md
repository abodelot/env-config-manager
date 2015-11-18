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

### Filters

 - `int` `user_id`: Filter on environments associated to given user id

### Get all environments

`[GET] /api/environments.json`

### Get environment

`[GET] /api/environments/:name.json`

### Update config for a given environment

```
[PUT] /api/environments/:name.json
{
  config: {
    key_1: "value_1",
    key_2: "value_2"
  }
}
```

### Delete environment

`[DELETE] /api/environments/:name.json`

- Associated variables will be deleted

## Users

### Filters

 - `string` *email*: Filter on users with given email
 - `string` *env_name*: Filter on users associated to given environment name

### Get all users

`[GET] /api/users/.json`

### Get user

`[GET] /api/users/:id.json`

