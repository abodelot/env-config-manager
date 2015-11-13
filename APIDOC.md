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

## Environments

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

## Users

`[GET] /api/users/.json`

`[GET] /api/users/:id.json`
