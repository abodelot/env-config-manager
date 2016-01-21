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

Example response:

```js
{
  "user": {
    "id": 2,
    "email": "user@domain.tld",
    "created_at": "2015-06-20T00:00:00.000Z",
    "updated_at": "2016-01-21T11:32:26.769Z"
  },
  "status": "ok",
  "authentication_token":"1kJGc4tV15g-Wn9McwZp"
}
```

You must include the returned `authentication_token` in the `Authorization`
request header to perform API calls as an authenticated user.
A user cannot open simultaneous sessions, opening a new session will invalidate
previously created authentication tokens. Example:

```ruby
request = Net::HTTP::Get.new(url)
request.add_field('Authorization', authentication_token)
```

## Environments

Note: `Environment` objects are identified by their `name` attribute, not by
their `id`.

### Filters

- `int` `user_id`: Filter on environments associated to given user id

### Methods

- Get all environments

    `[GET] /api/environments.json`

- Get environment

    `[GET] /api/environments/:name.json`

- Update config for a given environment

    ```
    [PUT] /api/environments/:name.json
    {
        config: {
            key_1: "value_1",
            key_2: "value_2"
        }
    }
    ```

- Delete environment

    `[DELETE] /api/environments/:name.json`

    - Associated variables will be deleted
    - Return no content

Users
-----

### Response fields

- `int` `id`
- `string` `email`

### Filters

- `string` `email`: Filter on users with given email
- `string` `env_name`: Filter on users associated to given environment name

### Methods

- Get all users

    `[GET] /api/users.json`

- Get user

    `[GET] /api/users/:id.json`

