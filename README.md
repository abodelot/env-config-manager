# Varager

Manage configuration variables for multiple environnements

## How to initialize

```
rake db:create db:migrate db:seed
```

## Tool stack

- Rails 4:
    - [devise](https://github.com/plataformatec/devise): User authentication
    - [ancestry](https://github.com/stefankroes/ancestry): Tree structure for environments
- Postgresql
- Front:
    - [pnotify](https://github.com/sciactive/pnotify): Notifications


## API

### Get list of environments

`[GET] /api/environments.json`

### Get config for a given environment

`[GET] /api/environments/#{name}.json`

### Update variables for a given environment

`[PUT] /api/environments/#{name}.json`

Payload:

```
{
  "variables": {
    "key_1": "value_1",
    "key_2": "value_2"
  }
}
```

